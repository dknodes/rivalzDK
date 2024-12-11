const pty = require("node-pty");

const os = require("os");


const walletAddress = process.env.WALLET_ADDRESS;
const cpuCores = process.env.CPU_CORES;
const ram = process.env.RAM;
const diskSize = process.env.DISK_SIZE;
const diskSelection = process.env.DISK_SELECTION || "";

if (!walletAddress || !cpuCores || !ram || !diskSize) {
  console.error(
    "Error : WALLET_ADDRESS, CPU_CORES, RAM, DISK_SIZE"
  );
  process.exit(1);
}

const ptyProcess = pty.spawn("rivalz", ["run"], {
  name: "xterm-color",
  cols: 80,
  rows: 30,
  cwd: process.env.HOME,
  env: process.env,
});

function sendInput(data) {
  if (data.includes("Enter wallet address (EVM):")) {
    ptyProcess.write(walletAddress + "\r");
  } else if (
    data.includes(
      "Enter number of CPU cores you want to allow the client to use:"
    )
  ) {
    ptyProcess.write(cpuCores);
  } else if (
    data.includes(
      "Enter amount of RAM (GB) you want to allow the client to use:"
    )
  ) {
    ptyProcess.write(ram);
  } else if (data.includes("Select drive you want to use:")) {
    if (diskSelection) {
      ptyProcess.write(diskSelection + "\r");
    }
  } else if (data.includes("Enter Disk size")) {
    ptyProcess.write(diskSize + "\r");
  }
}

// Écoute les données du processus
ptyProcess.on("data", function (data) {
  process.stdout.write(data);
  sendInput(data);
});

// Gère la fin du processus
ptyProcess.on("exit", function (code, signal) {
  console.log(
    `The process ended with the code ${code} and the signal ${signal}.`
  );
});