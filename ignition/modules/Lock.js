const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
    const token = m.contract("NFT", ["Rodrigo", "RDG", m.getAccount(0)]); // Asegúrate de pasar los argumentos requeridos
    return { token };
});
