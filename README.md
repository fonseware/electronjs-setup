# Electron.js Setup Script

This PowerShell script is designed to simplify the process of setting up and creating new Electron.js projects. Whether you're a beginner or an experienced developer, this script automates the installation of essential tools, initializes your project, and generates the necessary files to get you started quickly. It also provides options to create different types of Electron apps, including a basic Electron app, a Vite-based app, and a Windows-style app.

![image](https://github.com/shannonfonseka/shannonfonseka/blob/main/res/electronjs-home.png)
<p align="center">
  The homepage of the Electron.js Setup script.
</p>

## Features

- The script checks for and installs essential tools like Chocolatey, Node.js, and Visual Studio Code if they are not already installed on your system.
- You can now create a project without the setup wizard, just by passing parameters, see below.
- Automatically creates a new Electron.js project directory, initializes npm, and installs Electron as a dependency.
- Generates essential files such as main.js, index.html, and package.json with default configurations, saving you time on boilerplate code.
- Multiple Project Templates:
  - Basic Electron App: Creates a simple Electron app with default settings.
  - Vite-based Electron App: Uses the npm create @quick-start/electron command to set up a Vite-based Electron app for faster development.
  - Windows-style Electron App: Creates a modern Windows 10/11-style Electron app with custom window controls and a sleek UI.
- Automatically opens the newly created project in Visual Studio Code, allowing you to start coding immediately.
- Provides error logging and user-friendly prompts to guide you through the setup process, even if something goes wrong.

![image](https://github.com/shannonfonseka/shannonfonseka/blob/main/res/electronjs-setup.png)
<p align="center">
  A screenshot of the a basic electron app creation.
</p>

<br/>

![image](https://github.com/shannonfonseka/shannonfonseka/blob/main/res/electronjs-created.png)
<p align="center">
  A screenshot of the basic electron app created.
</p>

<br/>

![image](https://github.com/shannonfonseka/shannonfonseka/blob/main/res/electronjs-windows.png)
<p align="center">
  A screenshot of a windows styled electron app.
</p>

## Running the script

After cloning the repository, navigate to the project folder in your terminal and run the setup script to automatically configure your project. This script works for Windows operating systems only. Make sure you have git installed in your computer. If you are installing prerequisites, run the powershell terminal as an administrator.

### In PowerShell

**A quicker method:** You can now create Electron.js apps, more quickly using command line parameters. **This creates the basic project template, and ignores the prerequisite checks.**
```powershell
# run these commands in powershell.
git clone https://github.com/fonseware/electronjs-setup.git
cd electronjs-setup
./setup.ps1 -ProjectName "test-app" -ProjectLocation "C:\projects"

```

**For the normal wizard**:

```powershell
# run these commands in powershell.
git clone https://github.com/fonseware/electronjs-setup.git
cd electronjs-setup
./setup.ps1

```
### In Command Prompt (cmd)
To run the quick method:

```batch
:: run these commands in Command Prompt
git clone https://github.com/fonseware/electronjs-setup.git
cd electronjs-setup
powershell -ExecutionPolicy Bypass -File setup.ps1 -ProjectName "test-app" -ProjectLocation "C:\projects"

```

To run the normal wizard:

```batch
:: run these commands in Command Prompt
git clone https://github.com/fonseware/electronjs-setup.git
cd electronjs-setup
powershell -ExecutionPolicy Bypass -File setup.ps1

```

### **Alternative method**:
If you do not have git installed, you can try this method.

```
1. Download from the button above,
2. Extract the contents on your computer,
3. Run setup.ps1 on PowerShell.
```

## License

This script is licensed under the MIT License. Feel free to use, modify, and distribute it as per the terms of the license. For more details, see the [LICENSE](https://raw.githubusercontent.com/fonseware/electronjs-setup/refs/heads/main/LICENSE) file.

## Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request on the GitHub repository.

## Author

This script is developed and maintained by [shannonfonseka](https://github.com/shannonfonseka).
This script is designed to make Electron.js development more accessible and efficient, allowing you to focus on building your application rather than setting up the environment. Give it a try and let me know your feedback!
