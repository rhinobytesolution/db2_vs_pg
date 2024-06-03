extern crate odbc_safe;
extern crate prettytable;

pub mod db2;

#[rustler::nif]
fn insert() -> i64 {
    let _ = db2::insert();
    0
}

#[rustler::nif]
fn select() -> u16 {
    db2::select().unwrap()
}

rustler::init!("Elixir.Db2Wrapper", [insert, select]);
