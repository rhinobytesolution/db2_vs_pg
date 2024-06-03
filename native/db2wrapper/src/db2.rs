use ibm_db::{
    create_environment_v3,
    ResultSetState::{Data, NoData},
    Statement,
};
//use prettytable::Table;
use std::error::Error;

pub fn insert() -> Result<(), Box<dyn Error>> {
    let env = create_environment_v3().map_err(|e| e.unwrap())?;
    let conn = env.connect("db2vspg", "db2inst1", "password").unwrap();

    let stmt = Statement::with_parent(&conn)?;
    let sql_text =
        "INSERT INTO PUBLIC.players (username, pos_x, pos_y) VALUES ('10', '10', '10')".to_string();

    match stmt.exec_direct(&sql_text)? {
        Data(mut _stmt) => {}
        NoData(_) => {}
    }

    Ok(())
}

pub fn select() -> Result<u16, Box<dyn Error>> {
    let env = create_environment_v3().map_err(|e| e.unwrap())?;
    let conn = env.connect("db2vspg", "db2inst1", "password").unwrap();

    let stmt = Statement::with_parent(&conn)?;
    let sql_text = "SELECT pos_x FROM PUBLIC.players LIMIT 1".to_string();
    let mut res = 0;

    match stmt.exec_direct(&sql_text)? {
        Data(mut stmt) => {
            let cols = stmt.num_result_cols()?;
            while let Some(mut cursor) = stmt.fetch()? {
                for i in 1..(cols + 1) {
                    match cursor.get_data::<u16>(i as u16)? {
                        Some(val) => res = val,
                        None => {}
                    }
                }
            }
        }
        NoData(_) => println!("Query executed, no data returned"),
    }

    Ok(res)
}
