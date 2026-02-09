# NVM (Node Version Manager) 🟢

**Type:** Version manager for Node.js
**Purpose:** Manage multiple Node.js versions on your machine

**What it does:**

* Lets you **install different versions of Node.js**
* Switch between versions per project
* Useful if one project needs Node 18 and another needs Node 20

**Example:**

```bash
nvm install 22 
nvm use 22
node -v
```

**NVM does NOT:**

* Install libraries like React or Lodash
* Run your app
* Build your app

# npm (Node Package Manager) 📦

**Type:** Package manager
**Purpose:** Install, manage, and run packages (like React, Vite, Express)

**What it does:**

* Installs dependencies listed in `package.json`
* Runs scripts (`npm run dev`, `npm run build`)
* Manages versions of libraries

**Example:**

```bash
npm install react     # Install React
npm run dev           # Run dev script (usually Vite)
npm update            # Update packages
```

**npm does NOT:**

* Switch Node versions
* Manage multiple Node versions
