package db

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/lib/pq"
)

// Connect opens a connection to the RDS PostgreSQL instance using
// credentials resolved from environment variables, which are
// populated from AWS Secrets Manager at deploy time.
func Connect() (*sql.DB, error) {
	dsn := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=require",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"),
	)

	dbConn, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, fmt.Errorf("failed to open db connection: %w", err)
	}

	if err := dbConn.Ping(); err != nil {
		return nil, fmt.Errorf("failed to ping db: %w", err)
	}

	return dbConn, nil
}
