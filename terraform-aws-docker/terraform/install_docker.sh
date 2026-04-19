#!/bin/bash
# Update packages
sudo apt-get update -y

# Install prerequisite packages
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package database with Docker packages from the newly added repo
sudo apt-get update -y

# Install Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Create Sabari Sri's portfolio page
sudo mkdir -p /home/ubuntu/html
sudo tee /home/ubuntu/html/index.html > /dev/null <<'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Sabari Sri | Developer Portfolio</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --purple: #a78bfa;
      --blue: #60a5fa;
      --green: #4ade80;
      --orange: #fb923c;
      --bg: #07070f;
      --card: rgba(255,255,255,0.04);
      --border: rgba(255,255,255,0.08);
    }
    * { margin:0; padding:0; box-sizing:border-box; }
    html { scroll-behavior: smooth; }
    body {
      font-family: 'Inter', sans-serif;
      background: var(--bg);
      color: #e2e8f0;
      min-height: 100vh;
      overflow-x: hidden;
    }
    body::before, body::after {
      content: '';
      position: fixed;
      border-radius: 50%;
      filter: blur(120px);
      opacity: 0.12;
      pointer-events: none;
      z-index: 0;
    }
    body::before {
      width: 600px; height: 600px;
      background: var(--purple);
      top: -200px; left: -200px;
    }
    body::after {
      width: 500px; height: 500px;
      background: var(--blue);
      bottom: -150px; right: -150px;
    }
    nav {
      position: fixed; top: 0; width: 100%; z-index: 100;
      padding: 18px 60px;
      display: flex; justify-content: space-between; align-items: center;
      background: rgba(7,7,15,0.8);
      backdrop-filter: blur(20px);
      border-bottom: 1px solid var(--border);
    }
    .logo {
      font-weight: 800; font-size: 1.2rem;
      background: linear-gradient(90deg, var(--purple), var(--blue));
      -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    }
    .nav-links { display: flex; gap: 32px; }
    .nav-links a {
      color: rgba(255,255,255,0.5); text-decoration: none;
      font-size: 0.9rem; transition: color 0.3s;
    }
    .nav-links a:hover { color: #fff; }
    .hero {
      min-height: 100vh;
      display: flex; flex-direction: column;
      align-items: center; justify-content: center;
      text-align: center;
      padding: 100px 24px 60px;
      position: relative; z-index: 1;
    }
    .status-badge {
      display: inline-flex; align-items: center; gap: 8px;
      background: rgba(74,222,128,0.1);
      border: 1px solid rgba(74,222,128,0.3);
      border-radius: 50px; padding: 8px 20px;
      font-size: 0.8rem; color: var(--green);
      margin-bottom: 32px;
      animation: fadeDown 0.6s ease;
    }
    .dot {
      width: 8px; height: 8px;
      background: var(--green); border-radius: 50%;
      animation: pulse 1.5s infinite;
    }
    @keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:0.3;} }
    @keyframes fadeDown { from{opacity:0;transform:translateY(-20px);} to{opacity:1;transform:translateY(0);} }
    @keyframes fadeUp   { from{opacity:0;transform:translateY(30px);}  to{opacity:1;transform:translateY(0);} }
    h1.hero-name {
      font-size: clamp(3rem, 8vw, 5.5rem);
      font-weight: 800; line-height: 1.1;
      background: linear-gradient(135deg, #fff 30%, var(--purple) 70%, var(--blue));
      -webkit-background-clip: text; -webkit-text-fill-color: transparent;
      margin-bottom: 16px;
      animation: fadeUp 0.7s ease 0.1s both;
    }
    .hero-title {
      font-size: 1.2rem; font-weight: 400;
      color: rgba(255,255,255,0.5);
      margin-bottom: 24px;
      animation: fadeUp 0.7s ease 0.2s both;
    }
    .hero-title span { color: var(--purple); font-weight: 600; }
    .hero-desc {
      max-width: 580px; font-size: 1rem;
      color: rgba(255,255,255,0.4); line-height: 1.8;
      margin-bottom: 40px;
      animation: fadeUp 0.7s ease 0.3s both;
    }
    .hero-btns {
      display: flex; gap: 16px; flex-wrap: wrap; justify-content: center;
      animation: fadeUp 0.7s ease 0.4s both;
    }
    .btn {
      padding: 14px 32px; border-radius: 12px;
      font-weight: 600; font-size: 0.95rem;
      text-decoration: none; transition: all 0.3s;
    }
    .btn-primary {
      background: linear-gradient(135deg, var(--purple), var(--blue));
      color: #fff; border: none;
    }
    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 12px 40px rgba(167,139,250,0.3); }
    .btn-outline {
      background: transparent;
      border: 1px solid var(--border); color: rgba(255,255,255,0.7);
    }
    .btn-outline:hover { border-color: var(--purple); color: #fff; transform: translateY(-2px); }
    section { position: relative; z-index: 1; padding: 80px 24px; max-width: 900px; margin: 0 auto; }
    .section-label {
      font-size: 0.75rem; font-weight: 600; letter-spacing: 3px;
      text-transform: uppercase; color: var(--purple);
      margin-bottom: 12px;
    }
    .section-title {
      font-size: 2rem; font-weight: 700; color: #fff;
      margin-bottom: 48px;
    }
    .skills-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
      gap: 16px;
    }
    .skill-card {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 14px;
      padding: 24px 16px;
      text-align: center;
      transition: all 0.3s;
    }
    .skill-card:hover {
      border-color: var(--purple);
      background: rgba(167,139,250,0.08);
      transform: translateY(-4px);
    }
    .skill-icon { font-size: 2rem; margin-bottom: 10px; }
    .skill-name { font-size: 0.85rem; font-weight: 600; color: rgba(255,255,255,0.8); }
    .projects-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 24px; }
    .project-card {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 20px;
      padding: 32px;
      transition: all 0.3s;
    }
    .project-card:hover {
      border-color: rgba(167,139,250,0.4);
      transform: translateY(-6px);
      box-shadow: 0 20px 60px rgba(0,0,0,0.4);
    }
    .project-tag {
      display: inline-block;
      font-size: 0.7rem; font-weight: 600;
      letter-spacing: 2px; text-transform: uppercase;
      padding: 4px 12px; border-radius: 50px;
      margin-bottom: 16px;
    }
    .tag-devops    { background: rgba(167,139,250,0.15); color: var(--purple); }
    .tag-fullstack { background: rgba(96,165,250,0.15);  color: var(--blue); }
    .project-title { font-size: 1.3rem; font-weight: 700; color: #fff; margin-bottom: 10px; }
    .project-desc  { font-size: 0.9rem; color: rgba(255,255,255,0.45); line-height: 1.7; margin-bottom: 24px; }
    .tech-pills    { display: flex; flex-wrap: wrap; gap: 8px; }
    .tech-pill {
      font-size: 0.75rem; font-weight: 600;
      padding: 5px 14px; border-radius: 50px;
      border: 1px solid var(--border);
      color: rgba(255,255,255,0.5);
    }
    .infra-box {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 20px;
      padding: 32px;
      font-family: 'Courier New', monospace;
      font-size: 0.85rem;
      color: var(--green);
      line-height: 2;
    }
    .infra-comment { color: rgba(255,255,255,0.25); }
    .infra-key { color: var(--blue); }
    .infra-val { color: var(--orange); }
    footer {
      position: relative; z-index: 1;
      text-align: center; padding: 48px 24px;
      border-top: 1px solid var(--border);
    }
    .social-links { display: flex; justify-content: center; gap: 20px; margin-bottom: 24px; }
    .social-btn {
      display: flex; align-items: center; gap: 8px;
      padding: 12px 24px; border-radius: 10px;
      border: 1px solid var(--border);
      color: rgba(255,255,255,0.6); text-decoration: none;
      font-size: 0.9rem; font-weight: 500;
      transition: all 0.3s;
    }
    .social-btn:hover { border-color: var(--purple); color: #fff; transform: translateY(-2px); }
    .footer-note { font-size: 0.75rem; color: rgba(255,255,255,0.2); }
    .footer-note span { color: var(--purple); }
  </style>
</head>
<body>

  <nav>
    <div class="logo">SS</div>
    <div class="nav-links">
      <a href="#skills">Skills</a>
      <a href="#projects">Projects</a>
      <a href="#infra">Infrastructure</a>
    </div>
  </nav>

  <div class="hero">
    <div class="status-badge">
      <div class="dot"></div>
      Available for opportunities
    </div>
    <h1 class="hero-name">Sabari Sri</h1>
    <div class="hero-title">
      Full Stack Developer &amp; <span>DevOps Engineer</span>
    </div>
    <p class="hero-desc">
      Building real-world systems from hospital management platforms to
      fully automated cloud infrastructure. Passionate about databases,
      DevOps automation, and shipping things that actually work.
    </p>
    <div class="hero-btns">
      <a href="https://github.com/sabarisriammu" target="_blank" class="btn btn-primary">&#128193; GitHub Profile</a>
      <a href="#projects" class="btn btn-outline">View Projects &#8595;</a>
    </div>
  </div>

  <section id="skills">
    <div class="section-label">What I Know</div>
    <div class="section-title">Skills &amp; Technologies</div>
    <div class="skills-grid">
      <div class="skill-card"><div class="skill-icon">&#128452;</div><div class="skill-name">DBMS / MySQL</div></div>
      <div class="skill-card"><div class="skill-icon">&#128154;</div><div class="skill-name">Node.js</div></div>
      <div class="skill-card"><div class="skill-icon">&#9889;</div><div class="skill-name">Express.js</div></div>
      <div class="skill-card"><div class="skill-icon">&#128296;</div><div class="skill-name">Terraform</div></div>
      <div class="skill-card"><div class="skill-icon">&#9729;</div><div class="skill-name">AWS EC2 / VPC</div></div>
      <div class="skill-card"><div class="skill-icon">&#128051;</div><div class="skill-name">Docker</div></div>
      <div class="skill-card"><div class="skill-icon">&#128260;</div><div class="skill-name">Jenkins CI/CD</div></div>
      <div class="skill-card"><div class="skill-icon">&#127760;</div><div class="skill-name">HTML / CSS / JS</div></div>
    </div>
  </section>

  <section id="projects">
    <div class="section-label">What I Built</div>
    <div class="section-title">Projects</div>
    <div class="projects-grid">
      <div class="project-card">
        <div class="project-tag tag-devops">DevOps</div>
        <div class="project-title">&#9729; Automated Cloud Infrastructure</div>
        <p class="project-desc">
          Fully automated AWS infrastructure using Terraform. One command creates
          a VPC, subnet, internet gateway, security group, and EC2 instance then
          auto-deploys this portfolio via Docker. You are viewing it live right now.
        </p>
        <div class="tech-pills">
          <span class="tech-pill">Terraform</span>
          <span class="tech-pill">AWS EC2</span>
          <span class="tech-pill">Docker</span>
          <span class="tech-pill">Nginx</span>
          <span class="tech-pill">Jenkins</span>
          <span class="tech-pill">Bash</span>
        </div>
      </div>
      <div class="project-card">
        <div class="project-tag tag-fullstack">Full Stack</div>
        <div class="project-title">&#127973; PATIGO - Hospital Orchestrator</div>
        <p class="project-desc">
          A workflow-driven hospital management system that automates patient
          journeys across registration, consultation, lab, pharmacy, and billing
          using event-driven queues and role-based real-time dashboards.
        </p>
        <div class="tech-pills">
          <span class="tech-pill">Node.js</span>
          <span class="tech-pill">Express</span>
          <span class="tech-pill">MySQL</span>
          <span class="tech-pill">RBAC</span>
          <span class="tech-pill">Event Bus</span>
          <span class="tech-pill">REST API</span>
        </div>
      </div>
    </div>
  </section>

  <section id="infra">
    <div class="section-label">How This Page is Served</div>
    <div class="section-title">Live Infrastructure</div>
    <div class="infra-box">
      <span class="infra-comment"># This exact server was built by running one command:</span><br/>
      $ terraform apply<br/><br/>
      <span class="infra-comment"># Resources created automatically in ~2 minutes:</span><br/>
      <span class="infra-key">aws_vpc</span>              = <span class="infra-val">"10.0.0.0/16"</span><br/>
      <span class="infra-key">aws_subnet</span>           = <span class="infra-val">"10.0.1.0/24 (us-east-1a)"</span><br/>
      <span class="infra-key">aws_internet_gateway</span> = <span class="infra-val">attached</span><br/>
      <span class="infra-key">aws_security_group</span>   = <span class="infra-val">port 80, 22 open</span><br/>
      <span class="infra-key">aws_instance</span>         = <span class="infra-val">t3.micro (Free Tier)</span><br/>
      <span class="infra-key">docker container</span>     = <span class="infra-val">nginx:latest serving this page</span><br/><br/>
      <span class="infra-comment"># Zero manual steps. Zero clicking. Pure automation.</span>
    </div>
  </section>

  <footer>
    <div class="social-links">
      <a href="https://github.com/sabarisriammu" target="_blank" class="social-btn">
        &#128193; github.com/sabarisriammu
      </a>
    </div>
    <div class="footer-note">
      Designed &amp; Deployed by <span>Sabari Sri</span> &bull;
      Hosted on AWS EC2 &bull; Automated with <span>Terraform + Docker</span>
    </div>
  </footer>

</body>
</html>
HTMLEOF

# Run Nginx container with the portfolio mounted
sudo docker run -d -p 80:80 --name sample-nginx \
  -v /home/ubuntu/html:/usr/share/nginx/html:ro \
  nginx:latest
