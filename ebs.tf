resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.elasticsearch_storage.id
  instance_id = aws_instance.elasticsearch.id
}

resource "aws_ebs_volume" "elasticsearch_storage" {
  availability_zone = "us-east-1b"
  size              = 50
}