use criterion::{criterion_group, criterion_main, Criterion};

fn bench_insert(c: &mut Criterion) {
    c.bench_function("bench_insert", |b| {
        b.iter(|| {
            let _ = db2wrapper::db2::insert();
            ()
        });
    });
}

criterion_group!(benches, bench_insert,);
criterion_main!(benches);
