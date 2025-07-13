const express = require('express');
const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');
const cors = require('cors');
const path = require('path');

const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

const dbConfig = {
  host: 'localhost',
  user: 'root',           // Cambia si tu usuario es distinto
  password: 'angelito002',  // Cambia por tu contraseña de MySQL
  database: 'gestion_mascota',
};

// ===================================
// 🐾 REGISTRO DE DUEÑO
// ===================================
app.post('/api/registro', async (req, res) => {
  const { nombres, apellidos, dni, direccion, telefono, correo, contrasena } = req.body;

  if (!nombres || !apellidos || !dni || !direccion || !telefono || !correo || !contrasena) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  try {
    const conn = await mysql.createConnection(dbConfig);

    const [rows] = await conn.execute('SELECT ID_Dueno FROM dueno WHERE correo = ?', [correo]);

    if (rows.length > 0) {
      await conn.end();
      return res.status(400).json({ error: 'El correo ya está registrado' });
    }

    const hashedPassword = await bcrypt.hash(contrasena, 10);

    await conn.execute(
      `INSERT INTO dueno (nombres, apellidos, dni, direccion, telefono, correo, contrasena)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [nombres, apellidos, dni, direccion, telefono, correo, hashedPassword]
    );

    await conn.end();

    res.json({ mensaje: 'Registro exitoso' });
  } catch (error) {
    console.error('Error en /api/registro:', error);
    res.status(500).json({ error: 'Error en el servidor: ' + error.message });
  }
});

// ===================================
// 🔐 LOGIN
// ===================================
app.post('/api/login', async (req, res) => {
  const { correo, contrasena } = req.body;

  if (!correo || !contrasena) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  try {
    const conn = await mysql.createConnection(dbConfig);

    const [rows] = await conn.execute(
      'SELECT ID_Dueno, contrasena, nombres FROM dueno WHERE correo = ?',
      [correo]
    );

    await conn.end();

    if (rows.length === 0) {
      return res.status(400).json({ error: 'Correo o contraseña incorrectos' });
    }

    const user = rows[0];
    const passwordMatch = await bcrypt.compare(contrasena, user.contrasena);

    if (!passwordMatch) {
      return res.status(400).json({ error: 'Correo o contraseña incorrectos' });
    }

    res.json({ mensaje: `Bienvenido, ${user.nombres}`, idDueno: user.ID_Dueno });
  } catch (error) {
    console.error('Error en /api/login:', error);
    res.status(500).json({ error: 'Error en el servidor: ' + error.message });
  }
});

// ===================================
//  REGISTRO DE MASCOTA
// ===================================
app.post('/api/mascotas', async (req, res) => {
  const { nombre, especie, raza, edad, sexo, fechaNacimiento, estadoSalud, idDueno } = req.body;

  if (!nombre || !especie || !edad || !idDueno) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  try {
    const conn = await mysql.createConnection(dbConfig);

    await conn.execute(
      `INSERT INTO mascota (Nombre, Especie, Raza, Edad, Sexo, FechaNacimiento, EstadoSalud, ID_Dueno)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [nombre, especie, raza || null, edad, sexo || null, fechaNacimiento || null, estadoSalud || null, idDueno]
    );

    await conn.end();

    res.json({ mensaje: 'Mascota registrada con éxito' });
  } catch (error) {
    console.error('Error en /api/mascotas:', error);
    res.status(500).json({ error: 'Error en el servidor: ' + error.message });
  }
});

// ===================================
//  Obtener mascotas del dueño logueado
// ===================================
// 
app.get('/api/mis-mascotas/:idDueno', async (req, res) => {
  const { idDueno } = req.params;

  try {
    const conn = await mysql.createConnection(dbConfig);

    const [mascotas] = await conn.execute(
      `SELECT ID_Mascota, Nombre, Especie, Raza, Edad, Sexo, FechaNacimiento, EstadoSalud 
       FROM mascota 
       WHERE ID_Dueno = ?`,
      [idDueno]
    );

    await conn.end();

    res.json(mascotas);
  } catch (error) {
    console.error('Error en /api/mis-mascotas:', error);
    res.status(500).json({ error: 'Error al obtener mascotas' });
  }
});
// ===================================
//  agendar cita
// ===================================
// 
// Agendar nueva cita médica con veterinario disponible aleatorio
app.post('/api/citas', async (req, res) => {
  const { fecha, hora, motivo, diagnostico, tratamiento, idMascota } = req.body;

  if (!fecha || !hora || !motivo || !idMascota) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  try {
    const conn = await mysql.createConnection(dbConfig);

    // 1. Buscar veterinarios sin cita en ese horario
    const [disponibles] = await conn.execute(`
      SELECT v.ID_Veterinario, v.Nombres, v.Apellidos
      FROM veterinario v
      WHERE v.ID_Veterinario NOT IN (
        SELECT ID_Veterinario 
        FROM cita_medica 
        WHERE Fecha = ? AND Hora = ?
      )
    `, [fecha, hora]);

    if (disponibles.length === 0) {
      await conn.end();
      return res.status(400).json({ error: 'No hay veterinarios disponibles en ese horario.' });
    }

    // 2. Seleccionar uno aleatoriamente
    const aleatorio = disponibles[Math.floor(Math.random() * disponibles.length)];
    const idVeterinario = aleatorio.ID_Veterinario;

    // 3. Insertar la cita
    await conn.execute(
      `INSERT INTO cita_medica (Fecha, Hora, Motivo, Diagnostico, Tratamiento, ID_Mascota, ID_Veterinario)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [fecha, hora, motivo, diagnostico || '', tratamiento || '', idMascota, idVeterinario]
    );

    await conn.end();

    res.json({ mensaje: `Cita agendada con éxito con el Dr. ${aleatorio.Nombres} ${aleatorio.Apellidos}` });
  } catch (error) {
    console.error('Error en /api/citas:', error);
    res.status(500).json({ error: 'Error al agendar la cita' });
  }
});

// ===================================
//  mostrar cita
// ===================================
// 
app.get('/api/citas-dueno/:idDueno', async (req, res) => {
  const { idDueno } = req.params;

  try {
    const conn = await mysql.createConnection(dbConfig);

    const [citas] = await conn.execute(`
      SELECT 
        c.ID_Cita,
        c.Fecha,
        c.Hora,
        c.Motivo,
        c.Diagnostico,
        c.Tratamiento,
        m.Nombre AS NombreMascota,
        v.Nombres AS NombreVeterinario,
        v.Apellidos AS ApellidoVeterinario
      FROM cita_medica c
      JOIN mascota m ON c.ID_Mascota = m.ID_Mascota
      JOIN veterinario v ON c.ID_Veterinario = v.ID_Veterinario
      WHERE m.ID_Dueno = ?
      ORDER BY c.Fecha DESC, c.Hora DESC
    `, [idDueno]);

    await conn.end();

    res.json(citas);
  } catch (error) {
    console.error('Error en /api/citas-dueno:', error);
    res.status(500).json({ error: 'Error al obtener citas médicas' });
  }
});
// ===================================
// Obtener datos de un dueño por su ID
// ====================================

app.get('/api/dueno/:idDueno', async (req, res) => {
  const { idDueno } = req.params;

  try {
    const conn = await mysql.createConnection(dbConfig);

    const [rows] = await conn.execute(`
      SELECT Nombres, Apellidos, DNI, Direccion, Telefono, Correo
      FROM dueno
      WHERE ID_Dueno = ?
    `, [idDueno]);

    await conn.end();

    if (rows.length === 0) {
      return res.status(404).json({ error: 'Dueño no encontrado' });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error('Error en /api/dueno/:idDueno:', error);
    res.status(500).json({ error: 'Error al obtener datos del perfil' });
  }
});

// ===================================
// actualizar datos del dueño
// =======================================

app.put('/api/dueno/:idDueno', async (req, res) => {
  const { idDueno } = req.params;
  const {
    nombres,
    apellidos,
    dni,
    direccion,
    telefono,
    correo,
    contrasena
  } = req.body;

  if (!nombres || !apellidos || !dni || !direccion || !telefono || !correo || !contrasena) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios' });
  }

  try {
    const conn = await mysql.createConnection(dbConfig);

    const hashedPassword = await bcrypt.hash(contrasena, 10);

    await conn.execute(`
      UPDATE dueno 
      SET Nombres = ?, Apellidos = ?, DNI = ?, Direccion = ?, Telefono = ?, Correo = ?, Contrasena = ?
      WHERE ID_Dueno = ?
    `, [nombres, apellidos, dni, direccion, telefono, correo, hashedPassword, idDueno]);

    await conn.end();

    res.json({ mensaje: 'Perfil actualizado correctamente' });
  } catch (error) {
    console.error('Error al actualizar perfil:', error);
    res.status(500).json({ error: 'Error al actualizar perfil' });
  }
});


// ===================================
// borrar cita médica
// =======================================
app.delete('/api/citas/:idCita', async (req, res) => {
  const { idCita } = req.params;

  try {
    const conn = await mysql.createConnection(dbConfig);

    await conn.execute('DELETE FROM cita_medica WHERE ID_Cita = ?', [idCita]);

    await conn.end();

    res.json({ mensaje: 'Cita cancelada exitosamente' });
  } catch (error) {
    console.error('Error al cancelar cita:', error);
    res.status(500).json({ error: 'Error al cancelar la cita' });
  }
});


// ===================================
//  LOGIN DOCTOR
// ===================================
app.post('/api/login-doctor', async (req, res) => {
  const { correo, dni } = req.body;

  if (!correo || !dni) {
    return res.status(400).json({ error: 'Correo y DNI son obligatorios' });
  }

  try {
    const conn = await mysql.createConnection(dbConfig);

    const [rows] = await conn.execute(
      'SELECT ID_Veterinario, Nombres FROM veterinario WHERE Correo = ? AND DNI = ?',
      [correo, dni]
    );

    await conn.end();

    if (rows.length === 0) {
      return res.status(401).json({ error: 'Correo o DNI incorrectos' });
    }

    const doctor = rows[0];

    res.json({
      mensaje: 'Login exitoso',
      idVeterinario: doctor.ID_Veterinario,
      nombre: doctor.Nombres
    });
  } catch (error) {
    console.error('Error en /api/login-doctor:', error);
    res.status(500).json({ error: 'Error en el servidor' });
  }
});

// ===================================
// citas del doctor
// ===================================
app.get('/api/citas-doctor/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const conn = await mysql.createConnection(dbConfig);
    const [rows] = await conn.execute(`
      SELECT 
        c.ID_Cita, c.Fecha, c.Hora, c.Motivo, c.Atendida,
        m.Nombre AS NombreMascota,
        d.Nombres AS DuenoNombre,
        d.Apellidos AS DuenoApellido
      FROM cita_medica c
      JOIN mascota m ON c.ID_Mascota = m.ID_Mascota
      JOIN dueno d ON m.ID_Dueno = d.ID_Dueno
      WHERE c.ID_Veterinario = ?
      ORDER BY c.Fecha, c.Hora
    `, [id]);
    await conn.end();
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener citas' });
  }
});

// ===================================
//  Obtener una cita por ID
// ===================================
app.get('/api/cita/:idCita', async (req, res) => {
  const { idCita } = req.params;
  try {
    const conn = await mysql.createConnection(dbConfig);
    const [rows] = await conn.execute(`
      SELECT 
        c.ID_Cita, c.Fecha, c.Hora, c.Motivo, c.Diagnostico, c.Tratamiento, c.Atendida,
        m.Nombre AS NombreMascota,
        d.Nombres AS DuenoNombre,
        d.Apellidos AS DuenoApellido
      FROM cita_medica c
      JOIN mascota m ON c.ID_Mascota = m.ID_Mascota
      JOIN dueno d ON m.ID_Dueno = d.ID_Dueno
      WHERE c.ID_Cita = ?
    `, [idCita]);

    conn.end();

    if (rows.length === 0) return res.status(404).json({ error: 'Cita no encontrada' });
    res.json(rows[0]);
  } catch (err) {
    console.error('Error al obtener cita:', err);
    res.status(500).json({ error: 'Error al obtener cita' });
  }
});

app.put('/api/cita/:idCita/atendida', async (req, res) => {
  const { idCita } = req.params;
  try {
    const conn = await mysql.createConnection(dbConfig);
    await conn.execute('UPDATE cita_medica SET Atendida = TRUE WHERE ID_Cita = ?', [idCita]);
    conn.end();
    res.json({ mensaje: 'Cita marcada como atendida ✅' });
  } catch (err) {
    console.error('Error al actualizar cita:', err);
    res.status(500).json({ error: 'Error al actualizar cita' });
  }
});

// ===================================
// actualizar cita médica
// ===================================
app.put('/api/cita/:idCita', async (req, res) => {
  const { idCita } = req.params;
  const { diagnostico, tratamiento } = req.body;

  if (!diagnostico || !tratamiento) {
    return res.status(400).json({ error: 'Diagnóstico y tratamiento son requeridos' });
  }

  try {
    const conn = await mysql.createConnection(dbConfig);
    await conn.execute(`
      UPDATE cita_medica 
      SET Diagnostico = ?, Tratamiento = ? 
      WHERE ID_Cita = ?
    `, [diagnostico, tratamiento, idCita]);
    conn.end();
    res.json({ mensaje: 'Cita actualizada con éxito' });
  } catch (error) {
    console.error('Error al actualizar cita:', error);
    res.status(500).json({ error: 'Error al actualizar la cita' });
  }
});


// ===================================
// 🚀 INICIO DEL SERVIDOR
// ===================================
app.listen(port, () => {
  console.log(`Servidor backend corriendo en http://localhost:${port}`);
});
