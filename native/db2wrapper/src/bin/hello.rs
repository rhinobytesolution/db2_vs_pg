use db2wrapper::select;

fn main() {
    match select::connect() {
        Ok(()) => println!("Success"),
        Err(diag) => println!("Error: {}", diag),
    }
}
