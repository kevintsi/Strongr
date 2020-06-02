import Program from "../Models/Program"
import clt from "../core/config/database";

const repository = {};

repository.readProgram = async (req) => {
    let program_list = []
    let sql = `
        SELECT p.id_program, p.name, pg.name as program_goal_name, COUNT(ps.id_program) as session_count, 0 as tonnage
        FROM _program p
        JOIN _program_goal pg ON pg.id_program_goal = p.id_program_goal
        JOIN _program_session ps ON ps.id_program = p.id_program
        WHERE p.id_user = $1 
        GROUP BY p.id_program, p.name, pg.name
    `
    try {
        var result = await clt.query(sql, [req.user.id])
        if (result.rowCount > 0) {
            result.rows.forEach((row) => {
                program_list.push(new Program(row.id_program, row.name, row.program_goal_name, row.session_count, row.tonnage))
            })
        }
        console.log(program_list)
        return program_list
    } catch (error) {
        console.log(error)
    }

}


export default repository;