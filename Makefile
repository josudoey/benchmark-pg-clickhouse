PATH := ${CURDIR}/bin:$(PATH)

default: bench-clickhouse-1000 bench-postgres-1000

.PHONY: clean
clean: clean-clickhouse clean-postgres

.PHONY: clean-clickhouse
clean-clickhouse: goose-clickhouse-up goose-clickhouse-down

PHONY: clean-postgres
clean-postgres: goose-postgres-up goose-postgres-down

.PHONY: bench-clickhouse-100
bench-clickhouse-100: goose-clickhouse-up bench-clickhouse-insert-100 bench-clickhouse-query-100

.PHONY: bench-clickhouse-insert-100
bench-clickhouse-insert-100:
	go test -bench=BenchmarkClickHouseInsert -benchtime=100x -run=None -benchmem -timeout 1h ./driver/...

.PHONY: bench-clickhouse-query-100
bench-clickhouse-query-100:
	go test -bench=BenchmarkClickHouseQuery -benchtime=100x -run=None -benchmem -timeout 1h ./driver/...

.PHONY: bench-postgres-100
bench-postgres-100: goose-postgres-up bench-postgres-insert-100 bench-postgres-query-100

.PHONY: bench-postgres-insert-100
bench-postgres-insert-100:
	go test -bench=BenchmarkPostgresInsert -benchtime=100x -run=None -benchmem -timeout 1h ./driver/...

.PHONY: bench-postgres-query-100
bench-postgres-query-100:
	go test -bench=BenchmarkPostgresQuery -benchtime=100x -run=None -benchmem  -timeout 1h  ./driver/...


.PHONY: bench-clickhouse-1000
bench-clickhouse-1000: goose-clickhouse-up bench-clickhouse-insert-1000 bench-clickhouse-query-1000

.PHONY: bench-clickhouse-insert-1000
bench-clickhouse-insert-1000:
	go test -bench=BenchmarkClickHouseInsert -benchtime=1000x -run=None -benchmem -timeout 2h ./driver/...

.PHONY: bench-clickhouse-query-1000
bench-clickhouse-query-1000:
	go test -bench=BenchmarkClickHouseQuery -benchtime=1000x -run=None -benchmem -timeout 2h ./driver/...

.PHONY: bench-postgres-1000
bench-postgres-1000: goose-postgres-up bench-postgres-insert-1000 bench-postgres-query-1000

.PHONY: bench-postgres-insert-1000
bench-postgres-insert-1000:
	go test -bench=BenchmarkPostgresInsert -benchtime=1000x -run=None -benchmem -timeout 2h ./driver/...

.PHONY: bench-postgres-query-1000
bench-postgres-query-1000:
	go test -bench=BenchmarkPostgresQuery -benchtime=1000x -run=None -benchmem  -timeout 2h  ./driver/...



.PHONY: goose-postgres-up
goose-postgres-up: bin/goose
	@bin/goose -dir=./goose/postgres/migrations postgres '${POSTGRES_URL}' up

.PHONY: goose-clickhouse-up
goose-clickhouse-up: bin/goose
	@bin/goose -dir=./goose/clickhouse/migrations clickhouse '${CLICKHOUSE_URL}' up

.PHONY: goose-postgres-down
goose-postgres-down: bin/goose
	@bin/goose -dir=./goose/postgres/migrations postgres '${POSTGRES_URL}' down

.PHONY: goose-clickhouse-down
goose-clickhouse-down: bin/goose
	@bin/goose -dir=./goose/clickhouse/migrations clickhouse '${CLICKHOUSE_URL}' down

.PHONY: wire
wire: bin/wire
	bin/wire  ./...

bin/wire: go.sum
	GOBIN=$(abspath bin) go install github.com/google/wire/cmd/wire@v0.5.0

bin/goose: go.sum
	GOBIN=$(abspath bin) go install github.com/pressly/goose/v3/cmd/goose@v3.1.0
