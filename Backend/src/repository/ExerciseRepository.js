import AppExercise from "../Models/AppExercise"
import Exercise from "../Models/Exercise"
import Set from "../Models/Set"
import DetailExercise from "../Models/DetailExercise"
import clt from "../core/config/database";

const repository = {};

/**
 * create exercises 
 */
repository.createExercise = async (req) => {
    let date = new Date();
    let sqlCreateExercise = "INSERT INTO _exercise (id_app_exercise, id_user, name, id_equipment, creation_date, last_update) VALUES ($1, $2, $3, $4, $5, $6)"
    try {
        await clt.query(sqlCreateExercise, [req.body.id_app_exercise, req.user.id, req.body.name, req.body.id_equipment, date, date])
        return 201;
    }
    catch (error) {
        console.error(error)
    }
}

/// READ
repository.readExercises = async (req) => {
    let exercise_list = []
    let sqlReadAllExercices = `
    SELECT e.id_exercise, e.name as name_exercise, ae.name as name_app_exercise, COUNT(s.id_set) as set_count, null as tonnage
    FROM _exercise e
    JOIN _app_exercise ae ON ae.id_app_exercise = e.id_app_exercise
    JOIN _set s ON s.id_exercise = e.id_exercise
    WHERE e.id_user = $1
    GROUP BY e.id_exercise, e.name, ae.name, e.last_update
    ORDER BY e.last_update DESC
    `
    try {
        var result = await clt.query(sqlReadAllExercices, [req.user.id])
        if (result.rowCount > 0) {
            result.rows.forEach((row) => {
                exercise_list.push(new Exercise(row.id_exercise, row.name_exercise, row.name_app_exercise, row.set_count, row.tonnage))
            })
        }

        return exercise_list
    } catch (error) {
        console.log(error)
    }

}

/// UPDATE
repository.updateExercise = async (req) => {
    let date = new Date();
    let sqlUpdateExercise = "UPDATE _exercise SET id_app_exercise=$1, name=$2, id_equipment=$3, last_update=$4 WHERE id_exercise=$5 AND id_user=$6"
    try {
        await clt.query(sqlUpdateExercise, [req.body.id_app_exercise, req.body.name, req.body.id_equipment, date, req.params.id_exercise, req.user.id])
        return 200
    } catch (error) {
        console.log(error)
    }
}

/// DELETE
repository.deleteExercise = async (req) => {
    let sqlDeleteExercise = "DELETE FROM _exercise WHERE id_exercise = $1 AND id_user = $2"
    try {
        await clt.query(sqlDeleteExercise, [req.params.id_exercise, req.user.id])
        return 200
    } catch (error) {
        console.log(error)
    }
}

repository.detailExercise = async (req) => {
    let set_list = []
    let sql = `
    SELECT id_set, 1 as place, repetitions_count, rest_time, null as tonnage
    FROM _set s 
    WHERE s.id_exercise = $1;
    `
    try {

        let result = await clt.query(sql, [req.params.id_exercise])
        if (result.rowCount > 0) {
            result.rows.forEach(row => {
                set_list.push(new Set(row.id_set, row.place, row.repetitions_count, row.rest_time, row.tonnage))
            })
        }
        sql = `
        SELECT e.id_exercise, e.name as name_exercise, ae.id_app_exercise, ae.name as name_app_exercise, e.creation_date, e.last_update
        FROM _exercise e
        JOIN _app_exercise ae ON ae.id_app_exercise = e.id_app_exercise
        WHERE e.id_exercise = $1;
        `
        result = await clt.query(sql, [req.params.id_exercise])
        // console.log("result.rows: ", result.rows)
        let app_exercise = new AppExercise(result.rows[0].id_app_exercise, result.rows[0].name_app_exercise)
        // console.log("app_exercise: ", app_exercise)
        return new DetailExercise(result.rows[0].id_exercise, result.rows[0].name_exercise, app_exercise, set_list, result.rows[0].creation_date, result.rows[0].last_update)

    } catch (error) {
        console.log(error)
    }
}

export default repository;