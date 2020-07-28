import AppExercise from "../models/AppExercise";
import Exercise from "../models/Exercise";
import Set from "../models/Set";
import DetailExercise from "../models/DetailExercise";
import ExerciseMusclesTarget from "../models/ExerciseMusclesTarget";
import Muscle from "../models/Muscle";
import clt from "../core/config/database";
import Equipment from "../models/Equipment";

const repository = {};

/**
 * create exercises
 */
repository.createExercise = async (req) => {
  console.log(req.body);
  let date = new Date();
  let sqlCreateExercise =
    "INSERT INTO _exercise (id_app_exercise, id_user, name, id_equipment, creation_date, last_update) VALUES ($1, $2, $3, $4, $5, $6)";
  let sqlGetIdExercise =
    "SELECT id_exercise FROM _exercise WHERE id_user = $1 ORDER BY creation_date DESC LIMIT 1";
  try {
    await clt.query(sqlCreateExercise, [
      req.body.id_app_exercise,
      req.user.id,
      req.body.name,
      req.body.id_equipment,
      date,
      date,
    ]);
    let result = await clt.query(sqlGetIdExercise, [req.user.id]);

    req.body.sets.forEach(async (set) => {
      let parsed_set = JSON.parse(set);
      let sqlAddSet = `INSERT INTO _set (id_app_exercise, id_user, id_exercise, repetitions_count, rest_time, place) VALUES ($1, $2, $3, $4, $5, $6)`;
      await clt.query(sqlAddSet, [
        req.body.id_app_exercise,
        req.user.id,
        result.rows[0].id_exercise,
        parsed_set.repetitions_count,
        parsed_set.rest_time,
        parsed_set.place,
      ]);
    });
    return 201;
  } catch (error) {
    console.error(error);
  }
};
/// READ
repository.getExerciseID = async (id) => {
  try {
    let sqlExerciseID = `
    SELECT id_exercise
    FROM _exercise 
    WHERE id_user = $1
    ORDER BY last_update DESC
    `;
    return await clt.query(sqlExerciseID, [id]);
  } catch (error) {
    console.log(error)
  }

}

repository.readExercises = async (req) => {
  let exercise_list = [];

  let sqlReadAllExercices = `
    SELECT e.id_exercise, e.name as name_exercise, ae.name as name_app_exercise, 
    COUNT(s.id_set) as set_count, 
    (
      Select SUM(s.repetitions_count)
      From _set s
      WHERE s.id_exercise = $2
    ) as volume
    FROM _exercise e
    JOIN _app_exercise ae ON ae.id_app_exercise = e.id_app_exercise
    JOIN _set s ON s.id_exercise = e.id_exercise
    WHERE e.id_user = $1 AND e.id_exercise = $2
    GROUP BY e.id_exercise, e.name, ae.name, e.last_update
    `;
  try {
    let exercisesID = await repository.getExerciseID(req.user.id);
    if (exercisesID.rowCount > 0) {
      for (let index = 0; index < exercisesID.rows.length; index++) {
        let result = await clt.query(sqlReadAllExercices, [req.user.id, exercisesID.rows[index].id_exercise]);
        let id_exercise = result.rows[0].id_exercise
        let name_exercise = result.rows[0].name_exercise
        let name_app_exercise = result.rows[0].name_app_exercise
        let set_count = result.rows[0].set_count
        let volume = parseInt(result.rows[0].volume)

        exercise_list.push(
          new Exercise(
            id_exercise,
            name_exercise,
            name_app_exercise,
            set_count,
            volume
          )
        );
      }
    }
    return exercise_list;
  } catch (error) {
    console.log(error);
  }
};

/// UPDATE
repository.updateExercise = async (req) => {
  let sql =
    "UPDATE _exercise SET name = $1, last_update = $2, id_equipment = $3 WHERE id_exercise = $4 AND id_user = $5";
  try {
    await clt.query(sql, [
      req.body.name,
      new Date(),
      req.body.id_equipment,
      req.params.id_exercise,
      req.user.id,
    ]);
    sql = "DELETE FROM _set WHERE id_user = $1 AND id_exercise = $2";
    await clt.query(sql, [req.user.id, req.params.id_exercise]);
    sql = "SELECT id_app_exercise FROM _exercise WHERE id_exercise = $1";
    let result = await clt.query(sql, [req.params.id_exercise]);
    req.body.sets.forEach(async (set) => {
      let parsed_set = JSON.parse(set);
      sql =
        "INSERT INTO _set (id_user, id_exercise, id_app_exercise, place, repetitions_count, rest_time) VALUES ($1,$2,$3,$4,$5,$6)";
      await clt.query(sql, [
        req.user.id,
        req.params.id_exercise,
        result.rows[0].id_app_exercise,
        parsed_set.place,
        parsed_set.repetitions_count,
        parsed_set.rest_time,
      ]);
    });
    return 200;
  } catch (error) {
    console.log(error);
  }
};

/// DELETE
repository.deleteExercise = async (req) => {
  let sqlDeleteExercise =
    "DELETE FROM _exercise WHERE id_exercise = $1 AND id_user = $2";
  try {
    await clt.query(sqlDeleteExercise, [req.params.id_exercise, req.user.id]);
    return 200;
  } catch (error) {
    console.log(error);
  }
};

repository.detailExercise = async (req) => {
  let equipment = [];
  let set_list = [];
  let sql = `
    SELECT id_set, place, repetitions_count, rest_time, null as tonnage
    FROM _set s 
    WHERE s.id_exercise = $1
    ORDER BY s.place;
    `;
  try {
    let result = await clt.query(sql, [req.params.id_exercise]);
    if (result.rowCount > 0) {
      result.rows.forEach((row) => {
        set_list.push(
          new Set(
            row.id_set,
            row.place,
            row.repetitions_count,
            row.rest_time,
            row.tonnage
          )
        );
      });
    }
    sql = `
        SELECT e.id_exercise, e.name as name_exercise, ae.id_app_exercise, ae.name as name_app_exercise, e.creation_date, e.last_update
        FROM _exercise e
        JOIN _app_exercise ae ON ae.id_app_exercise = e.id_app_exercise
        WHERE e.id_exercise = $1;
        `;
    result = await clt.query(sql, [req.params.id_exercise]);
    // console.log("result.rows: ", result.rows)
    let app_exercise = new AppExercise(
      result.rows[0].id_app_exercise,
      result.rows[0].name_app_exercise
    );
    // console.log("app_exercise: ", app_exercise)
    sql = `
        SELECT eq.id_equipment, eq.name 
        FROM _exercise e JOIN _equipment eq ON eq.id_equipment = e.id_equipment
        WHERE e.id_exercise = $1 AND e.id_user = $2 AND e.id_app_exercise = $3
        `;
    let result_equipment = await clt.query(sql, [
      req.params.id_exercise,
      req.user.id,
      result.rows[0].id_app_exercise,
    ]);
    console.log(result_equipment);

    if (result_equipment.rowCount > 0) {
      equipment = new Equipment(
        result_equipment.rows[0].id_equipment,
        result_equipment.rows[0].name
      );
    }

    return new DetailExercise(
      result.rows[0].id_exercise,
      result.rows[0].name_exercise,
      app_exercise,
      equipment,
      set_list,
      result.rows[0].creation_date,
      result.rows[0].last_update
    );
  } catch (error) {
    console.log(error);
  }
};

repository.getExerciseMusclesTarget = async (req) => {
  var muscle_list = [];
  var list_exercise_muscles_target = [];
  var list_id_exercises = JSON.parse(req.body.id_exercises);
  try {
    for (let i = 0; i < list_id_exercises.length; i++) {
      let sql = `SELECT * FROM _exercise e WHERE e.id_exercise = $1 AND e.id_user = $2`;
      let result = await clt.query(sql, [list_id_exercises[i], req.user.id]);
      sql = `SELECT aem.id_app_exercise, aem.id_muscle, m.name FROM _app_exercise_muscle aem JOIN _muscle m ON aem.id_muscle = m.id_muscle WHERE aem.id_app_exercise = $1`;
      let result_app_exercise_muscle = await clt.query(sql, [
        result.rows[0].id_app_exercise,
      ]);
      console.log("Rows muscle", result_app_exercise_muscle.rows);
      result_app_exercise_muscle.rows.forEach((muscle) => {
        let muscle_found = muscle_list.filter(
          (_muscle) => muscle.id_muscle === _muscle.id
        );

        if (muscle_found.length === 0)
          muscle_list.push(new Muscle(muscle.id_muscle, muscle.name));
      });

      console.log("Muscle list ", muscle_list);

      list_exercise_muscles_target.push(
        new ExerciseMusclesTarget(list_id_exercises[i], muscle_list)
      );

      console.log("in for ", list_exercise_muscles_target);

      muscle_list = [];
    }

    return list_exercise_muscles_target;
  } catch (error) {
    console.error(error);
  }
};

repository.deleteExerciseAll = async (req) => {
  let sqlGetSession = `SELECT id_session FROM _session_exercise WHERE id_exercise = $1 AND id_user = $2`;

  let sqlGetAllExerciseFromSession = `SELECT id_exercise FROM _session_exercise WHERE id_session = $1 AND id_user = $2`;

  let sqlGetProgram = `SELECT id_program FROM _program_session WHERE id_session = $1 and id_user = $2`;

  let sqlGetAllSessionFromProgram = `SELECT id_session FROM _program_session WHERE id_program = $1 AND id_user = $2`;

  let sqlDeleteSessionExercise = `DELETE FROM _session_exercise WHERE id_exercise = $1 AND id_session = $2`;

  let sqlDeleteProgramSession = `DELETE FROM _program_session WHERE id_session = $1 AND id_user = $2`;

  let sqlDeleteExercise = `DELETE FROM _exercise WHERE id_exercise = $1 AND id_user = $2`;

  let sqlDeleteSession = ` DELETE FROM _session WHERE id_session = $1 AND id_user = $2`;

  let sqlDeleteProgram = `DELETE FROM _program WHERE id_program = $1 AND id_user = $2`;

  try {
    // get session dans lequel id_exercise present
    let resultForIdSession = await clt.query(sqlGetSession, [
      req.params.id_exercise,
      req.user.id,
    ]);
    let allSession;
    if (resultForIdSession.rowCount == 0) {
      repository.deleteCibleExercice(req.params.id_exercise);
    } else {
      allSession = resultForIdSession.rows[0].id_session;
    }
    // Pour chaque session
    resultForIdSession.rows.forEach(async (row) => {
      // get exercice de chaque session
      let resultAnyExercise = await clt.query(sqlGetAllExerciseFromSession, [
        row.id_session,
        req.user.id,
      ]);
      let allExercise = resultAnyExercise.rows;
      // si session a plus d'un exercice
      if (allExercise.length > 1) {
        await clt.query(sqlDeleteSessionExercise, [
          req.params.id_exercise,
          row.id_session,
        ]);
        repository.deleteCibleExercice(req.params.id_exercise);
        let result = await clt.query(
          "SELECT id_exercise FROM _session_exercise WHERE id_session = $1",
          [row.id_session]
        );

        for (let i = 0; i < result.rowCount; i++) {
          await clt.query(
            "UPDATE _session_exercise SET place = $1 WHERE id_exercise = $2 AND id_session = $3",
            [i + 1, result.rows[i].id_exercise, row.id_session]
          );
        }
      } else {
        // si session a un seul exercice
        // get program dans lequel cette session est presente
        let resultForIdProgram = await clt.query(sqlGetProgram, [
          row.id_session,
          req.user.id,
        ]);
        let selectIdSession = row.id_session;
        // si la seance n'appartient à aucun programme
        if (resultForIdProgram.rowCount == 0) {
          await clt.query(sqlDeleteSessionExercise, [
            req.params.id_exercise,
            row.id_session,
          ]);
          await clt.query(sqlDeleteProgramSession, [
            selectIdSession,
            req.user.id,
          ]);
          repository.deleteCibleExercice(req.params.id_exercise);
          await clt.query(sqlDeleteSession, [selectIdSession, req.user.id]);
        }
        resultForIdProgram.rows.forEach(async (r) => {
          // get toutes sessions de chaque programme dans lequel la session existe
          let resultAnySession = await clt.query(sqlGetAllSessionFromProgram, [
            r.id_program,
            req.user.id,
          ]);
          let allSession = resultAnySession.rows;
          // si session n'est pas unique dans chaque programme
          if (allSession.length > 1) {
            console.log("Le programme a plus d'une session");
            allSession.forEach(async (session) => {
              await clt.query(sqlDeleteSessionExercise, [
                allExercise[0].id_exercise,
                session.id_session,
              ]);
              await clt.query(sqlDeleteProgramSession, [
                selectIdSession,
                req.user.id,
              ]);
              // Vérification à faire ici
              repository.deleteCibleExercice(req.params.id_exercise);
              console.log(
                "L'ID de mon exercice est : ",
                allExercise[0].id_exercise
              );
              // await clt.query(sqlDeleteExercise, [
              //   allExercise[0].id_exercise,
              //   req.user.id,
              // ]);
              await clt.query(sqlDeleteSession, [selectIdSession, req.user.id]);
            });
          } else {
            await clt.query(sqlDeleteSessionExercise, [
              req.params.id_exercise,
              row.id_session,
            ]);
            await clt.query(sqlDeleteProgramSession, [
              allSession[0].id_session,
              req.user.id,
            ]);
            await clt.query(sqlDeleteExercise, [
              req.params.id_exercise,
              req.user.id,
            ]);
            await clt.query(sqlDeleteSession, [
              allSession[0].id_session,
              req.user.id,
            ]);

            await clt.query(sqlDeleteProgram, [r.id_program, req.user.id]);
          }
        });
      }
    });
    return 201;
  } catch (error) {
    console.error(error);
  }
};

repository.deleteCibleExercice = async (id_exercise) => {
  let sql = `DELETE FROM _exercise WHERE id_exercise = $1`;
  await clt.query(sql, [id_exercise]);
};

repository.deleteCibleSession = async (id_session) => {
  let sql = `DELETE FROM _session WHERE id_session = $1 `;
  await clt.query(sql, [id_session]);
};

repository.deleteCibleProgram = async (id_program) => {
  let sql = ` DELETE FROM _program WHERE id_program = $1`;
  await clt.query(sql, [id_program]);
};

repository.deleteCibleProgramSession = async (id_program, id_session) => {
  let sql = `  DELETE FROM _program_session WHERE id_session = $1 AND id_user = $2 `;
  await clt.query(sql, [id_program]);
};

repository.deleteCibleSessionExercise = async (id_session, id_exercise) => {
  let sql = `  DELETE FROM _session_exercise WHERE id_session = $1 AND id_exercise = $2 `;
  await clt.query(sql, [id_session, id_exercise]);
};

repository.getVolume = async (id_exercise, id_user) => {
  let sql = `
  SELECT
  (
     Select SUM(s.repetitions_count)
     From _set s
     WHERE s.id_exercise = $1::int
  ) as volume
  FROM _exercise
  WHERE id_exercise = $1::int AND id_user = $2::int
 
  `
  try {
    let res = await clt.query(sql, [id_exercise, id_user]);
    res.rows[0].volume = parseInt(res.rows[0].volume)
    return res.rows[0]

  } catch (error) {
    console.log(error)
  }

}

export default repository;



