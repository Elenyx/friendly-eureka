import { Client, Collection, Events } from 'discord.js';

export function registerInteractionCreate(
  client: Client,
  commands: Collection<string, any>,
) {
  client.on(Events.InteractionCreate, async (interaction) => {
    if (!interaction.isChatInputCommand()) return;

    const command = commands.get(interaction.commandName);
    if (!command) {
      console.error(`No command matching ${interaction.commandName} was found.`);
      return;
    }

    try {
      await command.execute(interaction);
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

export default registerInteractionCreate;
