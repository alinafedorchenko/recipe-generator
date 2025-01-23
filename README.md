# Rails Application Documentation

## Overview

This application serves as a recipe generation app powered by the Anthropic API. Users can generate recipes by entering a list of ingredients. 

To make it work, you must add your Anthropic API key to the .env file

## Prerequisites
Ensure the following tools and versions are installed before proceeding:

- **Ruby**: `3.1.0`
- **Rails**: Confirm the Rails version by running `rails -v` in the application directory.
- **Bundler**: Run `gem install bundler` to ensure Bundler is installed.
- **Node.js** and **Yarn**: Required for managing JavaScript assets.

---

## Setting Up the Application
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/alinafedorchenko/recipe-generator.git
   cd recipe-generator
   ```

2. **Install Dependencies**:
   Run the following command to install all required gems:
   ```bash
   bundle install
   ```

3. **Install JavaScript Dependencies and precompile assets**:
   ```bash
   yarn install
   rails assets:precompile
   ```

4. **Start the Server**:
   ```bash
   rails server
   ```
   Access the application at [http://localhost:3000](http://localhost:3000).
