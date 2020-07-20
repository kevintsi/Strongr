import bcrypt from "bcrypt";
import clt from "../core/config/database";

const repository = {};

/**
 * @param id_user int
 */
repository.getUser = async (req) => {
  let sqlGetUser = `
  SELECT u.id_user, u.email, u.password, u.firstname, u.lastname, u.phonenumber, u.birthdate, u.username, u.weight, u.signeddate, u.recoverycode,
	(
		SELECT COUNT(*) FROM _exercise e WHERE e.id_user = $1
	) as nb_exercises, 
	(
		SELECT COUNT(*) FROM _program prog WHERE prog.id_user = $1
	) as nb_programs,
		(
		SELECT COUNT(*) FROM _session sess WHERE sess.id_user = $1
	) as nb_sessions
	FROM _user u 
	WHERE u.id_user = $1
	GROUP BY u.id_user, u.email, u.password, u.firstname, u.lastname, u.phonenumber, u.birthdate, u.username, u.weight, u.signeddate, u.recoverycode
  `;
  try {
    var result = await clt.query(sqlGetUser, [req.user.id]);
    return result.rows[0];
  } catch (error) {
    console.error(error);
  }
};

repository.register = async (body) => {
  let res;
  let sqlExist = "SELECT * FROM _user u WHERE u.username = $1::varchar";
  try {
    var result = await clt.query(sqlExist, [body.username]);
    if (result.rows.length > 0) {
      res = 409;
    } else {
      let birth_to_datetime = new Date(body.birthdate);

      let sqlRegister =
        "INSERT INTO _user (email, password, firstname, lastname, phonenumber, birthdate, username, weight, signeddate) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9)";
      await clt.query(sqlRegister, [
        body.email,
        bcrypt.hashSync(body.password, 10),
        body.firstname,
        body.lastname,
        body.phonenumber,
        birth_to_datetime,
        body.username,
        parseFloat(body.weight),
        new Date(),
      ]);
      res = 201;
    }
    return res;
  } catch (error) {
    console.error(error);
  }
};

repository.checkEmail = async (email) => {
  let res;
  let sqlExistEmail = "SELECT * FROM _user u WHERE u.email = $1";
  try {
    var result = await clt.query(sqlExistEmail, [email]);
    if (result.rows.length > 0) {
      res = 409;
    } else {
      res = 200;
    }
    return res;
  } catch (error) {
    console.error(error);
  }
};

repository.updateUser = async (req) => {
  let res;
  let birth_to_datetime = new Date(req.body.birthdate);
  let sqlUpdate =
    "UPDATE _user SET firstname = $1::varchar, lastname = $2::varchar, username = $3::varchar, email = $4::varchar, birthdate = $5::date, phonenumber = $6::varchar, password = $7::varchar  WHERE id_user = $8::int";
  try {
    await clt.query(sqlUpdate, [
      req.body.firstname,
      req.body.lastname,
      req.body.username,
      req.body.email,
      birth_to_datetime,
      req.body.phonenumber,
      bcrypt.hashSync(req.body.password, bcrypt.genSaltSync(10)),
      req.user.id,
    ]);
    res = 200;
  } catch (error) {
    console.error(error);
    res = 501;
  }
  return res;
};

repository.deleteUser = async (req) => {
  let sqlDelete = "DELETE FROM _set WHERE id_user = $1::int";
  try {
    await clt.query(sqlDelete, [req.user.id]);
    sqlDelete = "DELETE FROM _user WHERE id_user = $1";
    await clt.query(sqlDelete, [req.user.id]);
    return 200;
  } catch (error) {
    console.log(error);
    return 501;
  }
};

repository.login = async (body) => {
  let sqlLogin;

  if (body.connectId.indexOf("@") != -1) {
    sqlLogin = "SELECT * FROM _user as u WHERE u.email = $1::varchar ";
  } else {
    sqlLogin = "SELECT * FROM _user as u WHERE u.username = $1::varchar ";
  }
  try {
    return await clt.query(sqlLogin, [body.connectId]);
  } catch (error) {
    console.log(error);
  }
};

repository.sendCode = async (email) => {
  try {
    let sqlEmailUser = "SELECT * FROM _user as u WHERE u.email = $1::varchar ";
    let result = await clt.query(sqlEmailUser, [email]);
    if (result.rows.length != 0) {
      let code = "";
      while (code.length < 8) {
        code += Math.floor(Math.random() * 9 + 1).toString();
      }
      let sqlChangeCode =
        "UPDATE _user SET recoverycode = $1::varchar WHERE id_user = $2::int";
      await clt.query(sqlChangeCode, [code, result.rows[0].id_user]);
      return code;
    } else {
      return 404;
    }
  } catch (error) {
    console.log(error);
  }
};

repository.checkCode = async (body) => {
  let sqlCheckCode =
    "SELECT * FROM _user WHERE email = $1::varchar AND recoverycode = $2::varchar";
  return await clt.query(sqlCheckCode, [body.email, body.code]);
};

repository.deleteCode = async (body) => {
  let sqlDeleteCode =
    "UPDATE _user SET recoverycode = NULL WHERE email = $1::varchar";
  try {
    await clt.query(sqlDeleteCode, [body.email]);
    return 200;
  } catch (error) {
    console.log(error);
    return error;
  }
};

repository.resetPassword = async (body) => {
  let sqlResetPassword =
    "UPDATE _user SET password = $1::varchar WHERE email = $2::varchar";
  try {
    return await clt.query(sqlResetPassword, [
      bcrypt.hashSync(body.password, 10),
      body.email,
    ]);
  } catch (error) {
    console.log(error);
  }
};

export default repository;
