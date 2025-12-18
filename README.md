# 📸 Galeria de Fotos na Nuvem com Terraform

Este projeto é uma **prática de infraestrutura na nuvem** utilizando **AWS + Terraform**, com o objetivo de consolidar conceitos fundamentais como:

- Infraestrutura como Código (IaC)
- Máquinas Virtuais (EC2)
- Storage na nuvem (S3)
- Redes (VPC, subnets, internet gateway)
- Segurança (IAM Roles, políticas de acesso)
- Automação e escalabilidade

A aplicação consiste em uma **galeria de imagens hospedada em um servidor Nginx (EC2)**, onde as imagens são armazenadas em um **bucket S3** e exibidas automaticamente na página web.

---

## 🧱 Arquitetura do Projeto

- **Amazon EC2**  
  Servidor web com Nginx responsável por exibir a galeria.

- **Amazon S3**  
  Armazena as imagens da galeria.

- **IAM Role**  
  Permite que a instância EC2 acesse o bucket S3 de forma segura, sem uso de credenciais fixas.

- **VPC e Subnet Pública**  
  Garantem conectividade com a internet.

Toda essa infraestrutura é criada automaticamente usando **Terraform**.

---

## 📋 Pré-requisitos

Antes de começar, você precisa ter:

- Conta na AWS
- AWS CLI configurada:
```bash
  aws configure
```
- Terraform instalado
👉 [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/install)

## 📂 Estrutura do Projeto
```
.
├── modules 
├── .gitignore
├── LICENSE
├── README.md
├── main.tf
└── variables.tf
```
## 🚀 Como subir a infraestrutura com Terraform
1. Inicializar o Terraform
Esse comando prepara o ambiente e baixa os providers necessários.
```bash
terraform init
```
2. Verificar o plano de execução
Mostra o que o Terraform vai criar, sem aplicar mudanças ainda.
```bash
terraform plan
```
3. Criar a infraestrutura
Aplica o plano e cria todos os recursos na AWS.
```bash
terraform apply
```
 4. Remover a infraestrutura (opcional)
Quando terminar a prática, você pode remover todos os recursos criados com:
```bash
terraform destroy
```

## 🎯 Objetivo educacional

Este projeto foi desenvolvido como atividade prática para reforçar conceitos de:
* Computação em nuvem
* Automação de infraestrutura
* Segurança na AWS
* Escalabilidade e boas práticas
