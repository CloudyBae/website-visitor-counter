resource "aws_dynamodb_table" "website-count-table" {
    name = "ViewCount"
    billing_mode = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "stats"
    
    attribute {
        name = "stats"
        type = "S"
    }

    tags = {
        Name        = "CloudResume"
}
