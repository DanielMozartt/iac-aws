# 🎓 Laboratório DevOps (Focado em Estudos)

Este repositório foi criado exclusivamente para **fins de estudo e prática de DevOps**. O objetivo deste laboratório é subir um site em HTML na AWS usando Kubernetes (K3s), Docker e Terraform.

O grande diferencial é a **automação autônoma**: a infraestrutura é criada e o Kubernetes é configurado inteiramente sozinho no primeiro boot da máquina. Não é necessário fazer acesso SSH para digitar comandos no servidor.

---

## 🛠️ O que foi feito neste projeto?

1. **Imagem Docker Multi-Arch (`Dockerfile`):** O site HTML foi containerizado e compilado para rodar em processadores AMD64 e ARM64.
2. **Infraestrutura Automatizada (Terraform):** Cria na AWS uma instância econômica `t4g.micro`, um IP Público e um Security Group (portas 22, 80 e 443 liberadas para a internet, e a porta do K3s restrita para o meu IP de estudante).
3. **Configuração Automática (`k3s_deployment.sh`):** Um script injetado pelo Terraform no boot da máquina que cria 2GB de memória Swap (para o servidor não travar) e instala o K3s com o Ingress Traefik.
4. **Orquestração Kubernetes (Manifestos YAML):** O próprio script de boot aplica as regras de `deployment`, `service` (do tipo **ClusterIP**) e `ingress` (porta 443 com criptografia TLS estática tradicional) e `redirect` redirecionando a porta 80 (http) para 443(https).
5. **Automações Locais (PowerShell e Bash):** Scripts espelhados que disparam o ciclo de vida do Terraform (`apply` e `destroy`) e retornam o ip público da instância criada.

---

**Desenvolvido para aprendizado continuo prático de conceitos de DevOps e Cloud.**
