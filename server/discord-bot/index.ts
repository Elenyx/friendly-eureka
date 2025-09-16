import 'dotenv/config';
import { Client, GatewayIntentBits, Collection, Events, REST, Routes } from 'discord.js';
import registerReady from './events/ready.js';
import registerInteractionCreate from './events/interactionCreate.js';
import { storage } from '../storage.js';
import { exploreCommand } from './commands/explore.js';
import { scanCommand } from './commands/scan.js';
import { jumpCommand } from './commands/jump.js';
import { battleCommand } from './commands/battle.js';
import { profileCommand } from './commands/profile.js';
import { marketCommand } from './commands/market.js';

const DISCORD_BOT_TOKEN = process.env.DISCORD_BOT_TOKEN || 'your_bot_token';
const DISCORD_CLIENT_ID = process.env.DISCORD_CLIENT_ID || 'your_client_id';

class NexiumBot {
  private client: Client;
  private commands: Collection<string, any>;

  constructor() {
    this.client = new Client({
      intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent,
      ],
    });

    this.commands = new Collection();
    this.setupCommands();
    this.setupEventHandlers();
  }

  private setupCommands() {
    const commands = [
      exploreCommand,
      scanCommand,
      jumpCommand,
      battleCommand,
      profileCommand,
      marketCommand,
    ];

    for (const command of commands) {
      this.commands.set(command.data.name, command);
    }
  }

  private setupEventHandlers() {
    registerReady(this.client);
    // Wrap handler to pass commands and storage into execute
    this.client.on(Events.InteractionCreate, async (interaction) => {
      if (!interaction.isChatInputCommand()) return;
      const command = this.commands.get(interaction.commandName);
      if (!command) return;
      try {
        await command.execute(interaction, storage);
      } catch (error) {
        console.error('Error executing command:', error);
        const errorMessage = { content: 'There was an error while executing this command!', ephemeral: true } as const;
        try {
          if (interaction.replied || interaction.deferred) {
            await interaction.followUp(errorMessage);
          } else {
            await interaction.reply(errorMessage);
          }
        } catch {}
      }
    });
  }

  async deployCommands() {
    const rest = new REST().setToken(DISCORD_BOT_TOKEN);

    try {
      console.log('Started refreshing application (/) commands.');

      const commandData = this.commands.map(command => command.data.toJSON());

      await rest.put(
        Routes.applicationCommands(DISCORD_CLIENT_ID),
        { body: commandData },
      );

      console.log('Successfully reloaded application (/) commands.');
    } catch (error) {
      console.error('Error deploying commands:', error);
    }
  }

  async start() {
    if (!process.env.DISCORD_BOT_TOKEN || process.env.DISCORD_BOT_TOKEN === 'your_bot_token') {
      console.warn('DISCORD_BOT_TOKEN is not set or is a placeholder; bot will not start.');
      return;
    }
    await this.deployCommands();
    await this.client.login(DISCORD_BOT_TOKEN);
  }

  getClient() {
    return this.client;
  }
}

// Initialize and start bot if running directly
if (process.argv[1] && process.argv[1].includes('discord-bot/index')) {
  const bot = new NexiumBot();
  bot.start().catch(console.error);
}

export { NexiumBot };
