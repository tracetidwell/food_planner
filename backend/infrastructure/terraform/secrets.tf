/**
 * AWS Secrets Manager
 */

resource "aws_secretsmanager_secret" "openai_api_key" {
  name                    = "${var.project_name}/${var.environment}/openai-api-key"
  description             = "OpenAI API key for meal plan generation"
  recovery_window_in_days = 7

  tags = {
    Name        = "${var.project_name}-openai-key"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "openai_api_key" {
  secret_id     = aws_secretsmanager_secret.openai_api_key.id
  secret_string = var.openai_api_key
}

resource "aws_secretsmanager_secret" "jwt_secret_key" {
  name                    = "${var.project_name}/${var.environment}/jwt-secret-key"
  description             = "JWT secret key for authentication"
  recovery_window_in_days = 7

  tags = {
    Name        = "${var.project_name}-jwt-key"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "jwt_secret_key" {
  secret_id     = aws_secretsmanager_secret.jwt_secret_key.id
  secret_string = var.jwt_secret_key
}

resource "aws_secretsmanager_secret" "encryption_key" {
  name                    = "${var.project_name}/${var.environment}/encryption-key"
  description             = "Encryption key for user API keys"
  recovery_window_in_days = 7

  tags = {
    Name        = "${var.project_name}-encryption-key"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "encryption_key" {
  secret_id     = aws_secretsmanager_secret.encryption_key.id
  secret_string = var.encryption_key
}
