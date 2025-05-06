module github.com/ammohan6212/go-backend

go 1.20

require (
    github.com/gin-gonic/gin v1.9.1                    // Web framework
    github.com/sirupsen/logrus v1.9.3                  // Logging
    github.com/joho/godotenv v1.4.0                    // Load environment variables from .env
    github.com/go-playground/validator/v10 v10.14.1    // Input validation
    github.com/jmoiron/sqlx v1.3.5                     // Database helper
    github.com/lib/pq v1.10.9                          // PostgreSQL driver
    github.com/stretchr/testify v1.8.4                 // Testing assertions
    github.com/google/uuid v1.3.0                      // UUID generation
    golang.org/x/crypto v0.18.0                        // Cryptographic primitives
)
