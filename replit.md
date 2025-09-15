# Nexium RPG - Space Exploration Discord Bot

## Overview

Nexium RPG is a space exploration Discord bot and web application built with React, Express, and PostgreSQL. The system provides a comprehensive MMO-style gaming experience where players can explore procedurally generated space sectors, command starships, engage in combat, participate in a player-driven economy, and build cosmic empires. The application features both Discord bot commands for in-game interactions and a modern web dashboard for fleet management and market activities.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **React SPA**: Built with Vite for fast development and optimized builds
- **UI Framework**: Shadcn/ui components with Radix UI primitives for accessibility
- **Styling**: Tailwind CSS with custom space-themed design tokens and dark mode support
- **State Management**: TanStack Query for server state management and caching
- **Authentication**: Session-based auth with Discord OAuth2 integration
- **Routing**: Wouter for lightweight client-side routing

### Backend Architecture
- **Express Server**: RESTful API with TypeScript for type safety
- **Database Layer**: Drizzle ORM with PostgreSQL for structured data persistence
- **Real-time Communication**: WebSocket support for live game updates
- **Session Management**: Express-session with PostgreSQL store for user sessions
- **Discord Integration**: Discord.js for bot commands and Discord OAuth2 for web authentication

### Core Game Systems
- **Universe Generation**: Procedural sector generation with coordinates, resources, and hazards
- **Ship Management**: Multi-ship ownership with upgrades, customization, and combat stats
- **Exploration System**: Energy-based exploration with risk/reward mechanics
- **Combat Engine**: Turn-based ship-to-ship combat with strategic elements
- **Economy**: Player-driven marketplace with dynamic pricing and resource trading
- **Progression**: Experience-based leveling system with rankings and achievements

### Database Schema Design
- **Users**: Discord integration with energy system, currency, and progression tracking
- **Ships**: Customizable starships with stats, upgrades, and cosmetic options
- **Sectors**: Procedurally generated space regions with resources and discovery tracking
- **Items & Inventory**: Comprehensive item system with rarity and trading capabilities
- **Market**: Player-to-player trading with listing management and pricing
- **Guilds**: Player organizations with membership and collaboration features

### Authentication and Authorization
- **Discord OAuth2**: Primary authentication method for both web and bot
- **Session-based Auth**: Secure session management with PostgreSQL storage
- **Role-based Access**: User permissions tied to Discord roles and game progression

## External Dependencies

### Core Infrastructure
- **Neon Database**: PostgreSQL hosting for production data persistence
- **Discord API**: Bot functionality and OAuth2 authentication
- **WebSocket Protocol**: Real-time communication for live game updates

### Development and Build Tools
- **Vite**: Frontend build system with React and TypeScript support
- **Drizzle Kit**: Database migration and schema management
- **ESBuild**: Server-side bundling for production deployment

### UI and Styling Libraries
- **Radix UI**: Accessible component primitives for complex UI elements
- **Tailwind CSS**: Utility-first CSS framework with custom design system
- **Lucide React**: Consistent icon library for space-themed interface

### Game and Communication Libraries
- **Discord.js**: Discord bot framework for slash commands and interactions
- **Passport.js**: Authentication middleware with Discord strategy
- **TanStack Query**: Server state management with intelligent caching

### Utility Libraries
- **Zod**: Runtime type validation for API endpoints and form handling
- **Date-fns**: Date manipulation for game timers and scheduling
- **Nanoid**: Unique identifier generation for game entities