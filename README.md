# Electron.JS Setup `v1.6`
Welcome to **Electron.JS Setup**, a powerful and easy-to-use script designed to quickly set up your Electron.js projects. Whether you're a beginner or an experienced developer, this script will streamline the process of creating a new Electron app from scratch.

![image](https://github.com/shannonfonseka/shannonfonseka/blob/main/res/home.png)

## Features
- No need to manually configure your project. Just answer a few simple prompts, and the script does the rest.
- It automatically checks and installs essential tools such as Chocolatey, Visual Studio Code, and Node.js.
- It creates a new Electron project directory, sets up npm, installs Electron, and generates the essential files (like `main.js` and `index.html`).
- Once your project is set up, the script opens it directly in Visual Studio Code, so you can start coding right away.
- From initializing your project to launching the app, the script takes care of every step, so you don't have to.

![image](https://github.com/shannonfonseka/shannonfonseka/blob/main/res/setup.png)

![image](https://github.com/shannonfonseka/shannonfonseka/blob/main/res/created.png)

## Running the Setup
>[!CAUTION]
> This script was just released, there may be bugs when using this script. Please report any bugs in the issues page.

>[!WARNING]
>Close the script after installing certain prerequisites and restart your computer.

After cloning the repository, navigate to the project folder in your terminal and run the setup script to automatically configure your environment:

**For Windows**: Run `setup.ps1` in Command Prompt (requires Git installed):
```cmd
git clone https://github.com/fonseware/electronjs-setup.git
cd electronjs-setup
powershell -ExecutionPolicy Bypass -File setup.ps1

```
**For Windows**: Run `setup.ps1` in PowerShell (requires Git installed):
```powershell
git clone https://github.com/fonseware/electronjs-setup.git
cd electronjs-setup
./setup.ps1
```
**Alternative method**:
```
Download from the button above,
Extract the contents on your computer,
Run setup.ps1 on PowerShell.
```

## License
This project is under the MIT License - see the [LICENSE](https://raw.githubusercontent.com/fonseware/electronjs-setup/refs/heads/main/LICENSE) file for details.

## Support
For any issues or improvements, submit them on GitHub issues or contact @shannonfonseka
