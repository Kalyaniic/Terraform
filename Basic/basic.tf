resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.user_one.name,
    aws_iam_user.user_two.name,
    aws_iam_user.user_three.name,
  ]

  group = aws_iam_group.team1.name
}

resource "aws_iam_group" "team1" {
  name = "team1"
}

resource "aws_iam_user" "user_one" {
  name = "user_one"
}

resource "aws_iam_user" "user_two" {
  name = "user_two"
}

resource "aws_iam_user" "user_three" {
  name = "user_three"
}