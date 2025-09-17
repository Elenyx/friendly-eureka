import 'dotenv/config';
import { REST, Routes } from 'discord.js';
import { exploreCommand } from './commands/explore.js';
import { scanCommand } from './commands/scan.js';
import { jumpCommand } from './commands/jump.js';
import { battleCommand } from './commands/battle.js';
import { profileCommand } from './commands/profile.js';
import { marketCommand } from './commands/market.js';

const DISCORD_BOT_TOKEN = process.env.DISCORD_BOT_TOKEN || 'your_bot_token';
const DISCORD_CLIENT_ID = process.env.DISCORD_CLIENT_ID || 'your_client_id';

async function registerCommands() {
  if (!DISCORD_BOT_TOKEN || DISCORD_BOT_TOKEN === 'your_bot_token') {
    console.error('DISCORD_BOT_TOKEN is not set or is a placeholder.');
    process.exit(1);
  }

  if (!DISCORD_CLIENT_ID || DISCORD_CLIENT_ID === 'your_client_id') {
    console.error('DISCORD_CLIENT_ID is not set or is a placeholder.');
    process.exit(1);
  }

  const commands = [
    exploreCommand,
    scanCommand,
    jumpCommand,
    battleCommand,
    profileCommand,
    marketCommand,
  ];

  const rest = new REST().setToken(DISCORD_BOT_TOKEN);

  try {
    console.log('Started refreshing application (/) commands.');

    const commandData = commands.map(command => command.data.toJSON());

    await rest.put(
      Routes.applicationCommands(DISCORD_CLIENT_ID),
      { body: commandData },
    );

    console.log('Successfully reloaded application (/) commands.');
  } catch (error: any) {
    console.error('Error deploying commands:', error.message || error);
    if (error.response) {
      console.error('HTTP Status:', error.response.status);
      console.error('Response Data:', error.response.data);
    }
    process.exit(1);
  }
}

registerCommands();