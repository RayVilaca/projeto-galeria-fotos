data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = var.ec2_service_role.name
}

resource "aws_instance" "ec2_server" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t3.micro"
  subnet_id                   = var.vpc.public_subnets[0]
  vpc_security_group_ids      = [var.security_group.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true

  tags = {
    Name = "galeria-server"
  }

  user_data = <<-TERRAFORM-EOF
              #!/bin/bash
              BUCKET="galeria-fotos-womakerscode"
              HTML_DIR="/usr/share/nginx/html"
              IMG_DIR="$HTML_DIR/images"
              HTML="$HTML_DIR/index.html"
              yum install -y nginx aws-cli > /dev/null
              systemctl enable nginx
              systemctl start nginx

              mkdir -p $IMG_DIR
              rm -f $IMG_DIR/*
              aws s3 sync s3://$BUCKET $IMG_DIR --exclude "" --include ".jpg" --include ".jpeg" --include ".png" --include "*.gif"
              cat > $HTML <<'EOF'
              <!DOCTYPE html>
              <html lang="pt-br">
              <head>
              <meta charset="UTF-8">
              <title>Galeria na Nuvem</title>
              <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

              <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

              <style>
                  * { box-sizing: border-box; margin: 0; padding: 0; }

                  body {
                  font-family: 'Poppins', sans-serif;
                  min-height: 100vh;
                  background: linear-gradient(135deg, #6a11cb, #ff5f9e);
                  padding: 50px 20px;
                  color: #333;
                  }

                  h1 {
                  text-align: center;
                  color: #fff;
                  font-size: 42px;
                  margin-bottom: 10px;
                  }

                  .info {
                    position: fixed;
                    bottom: 25px;
                    right: 25px;
                    background: rgba(0, 0, 0, 0.35);
                    backdrop-filter: blur(8px);
                    padding: 16px 22px;
                    border-radius: 20px;
                    color: #ffffff;
                    font-size: 14px;
                    line-height: 1.6;
                    box-shadow: 0 8px 20px rgba(0,0,0,0.35);
                  }

                  .info strong {
                    color: #ffffff;
                    font-weight: 600;
                  }

                  .subtitle {
                  text-align: center;
                  color: rgba(255,255,255,0.9);
                  margin-bottom: 40px;
                  }

                  .gallery {
                  max-width: 1300px;
                  margin: 0 auto;
                  display: grid;
                  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
                  gap: 30px;
                  }

                  .card {
                  background: #fff;
                  border-radius: 18px;
                  overflow: hidden;
                  box-shadow: 0 15px 35px rgba(0,0,0,0.25);
                  transition: transform 0.3s ease;
                  }

                  .card:hover {
                  transform: translateY(-8px);
                  }

                  .image-wrapper {
                  height: 240px;
                  overflow: hidden;
                  }

                  .image-wrapper img {
                  width: 100%;
                  height: 100%;
                  object-fit: cover;
                  }

                  .card-footer {
                  padding: 14px;
                  text-align: center;
                  background: #f7f7f7;
                  font-size: 14px;
                  word-break: break-word;
                  }
              </style>
              </head>

              <body>
              <h1>✨ Galeria na Nuvem</h1>
              <p class="subtitle">Imagens sincronizadas automaticamente do Amazon S3</p>

              <div class="gallery">
              EOF
              for IMAGE in $IMG_DIR/*; do
                FILE=$(basename "$IMAGE")

                cat >> $HTML <<INNER_EOF
                  <div class="card">
                    <div class="image-wrapper">
                      <img src="images/$FILE" alt="$FILE">
                    </div>
                    <div class="card-footer">$FILE</div>
                  </div>
              INNER_EOF
              done
              cat >> $HTML <<EOF
                </div>
              </body>
              </html>
              EOF
              sudo nano /usr/local/bin/atualiza-galeria.sh
              sudo chmod +x /usr/local/bin/atualiza-galeria.sh
              sudo /usr/local/bin/atualiza-galeria.sh
              TERRAFORM-EOF

}
