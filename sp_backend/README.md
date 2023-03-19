# Splitee - API

All the backend code for Splitee.

## [Postman Documentation](https://documenter.getpostman.com/view/19943106/2s93JzMg4z)

## Why did I use this stack?

### Why TypeScript?

- Always wanted to use it in a project
- Likes type-safety

### Why Express?

- Big ecosystem
- Easy to use

### Why MongoDB?

- Always wanted to use it in a project
- Flexibility
- Scalability
- Easy to deploy (MongoDB Atlas)

### Why Prisma?

- Easy to use
- Always wanted to use it in a project

## Setup

Assuming you have Node.js installed, run the following commands:

- Clone the repository
- Change directory to `sp_backend`
- Run `npm install`
- Install ts-node globally with `npm install -g ts-node`
- Install dependencies with `npm install`
- Set up environment variables

```
# Configure your API port
PORT=5000

# Log level
LOG_LEVEL=combined

# Secret key for JWT
JWT_SECRET=

# MongoDB connection string
DATABASE_URL=

```

- Run `npm run dev` to start the server (in development mode), or `npm run start` to start the server (in production mode)
