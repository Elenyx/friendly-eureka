import { Client, Events } from 'discord.js';

export function registerReady(client: Client) {
  client.once(Events.ClientReady, (readyClient) => {
    const tag = readyClient.user?.tag ?? readyClient.user?.username ?? 'bot';
    console.log(`🚀 Nexium RPG Bot is online! Logged in as ${tag}`);
    // Optional: set a presence
    try {
      readyClient.user.setPresence({
        activities: [{ name: 'Nexium RPG', type: 0 }],
        status: 'online',
      });
    } catch {}
  });
}

export default registerReady;
