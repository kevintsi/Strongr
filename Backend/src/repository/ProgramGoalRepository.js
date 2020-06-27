import ProgramGoal from "../Models/ProgramGoal"
import clt from "../core/config/database";

const repository = {};


repository.readProgramGoal = async (req) => {
    let program_goal_list = []
    let sql = `
        SELECT id_program_goal, name, description
        FROM _program_goal
    `
    try {
        var result = await clt.query(sql)
        if (result.rowCount > 0) {
            result.rows.forEach((row) => {
                program_goal_list.push(new ProgramGoal(row.id_program_goal, row.name, row.description))
            })
        }
        console.log(program_goal_list)
        return program_goal_list
    } catch (error) {
        console.log(error)
    }

}

repository.readProgramGoalById = async (req) => {
    let sql = `
        SELECT id_program_goal, name, description
        FROM _program_goal
        WHERE id_program_goal = $1
    `
    try {
        let result = await clt.query(sql, [req.params.id_program_goal]);
        return result.rows[0];
    } catch (error) {
        console.log(error);
    }

}


export default repository;