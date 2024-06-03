fn main() {
    match db2wrapper::db2::insert() {
        Ok(()) => println!("Success"),
        Err(diag) => println!("Error: {}", diag),
    }

    match db2wrapper::db2::select() {
        Ok(val) => println!("{}", val),
        Err(diag) => println!("Error: {}", diag),
    }
}
