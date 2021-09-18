resource "aws_iam_user" "mizzy" {
  name = "mizzy"
}

resource "aws_iam_access_key" "mizzy" {
  user = aws_iam_user.mizzy.name
}
