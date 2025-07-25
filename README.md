# 🛠️ User Management Script

A Bash script to manage Linux users with SSH key setup and optional restrictions. Supports creating users with a regular or limited environment, resetting SSH keys, and removing users.

---

## 📦 Features

- ✅ Create regular or restricted users
- 🔐 Generate SSH key pairs and configure `authorized_keys`
- 🧼 Remove users, with or without home directory
- 🛡️ Restricted user mode with limited command access (`rbash`)
- 🧾 Compatible with standard Linux systems (Debian/Ubuntu)

---

## 📌 Usage

```bash
./manage-user [username] [OPTION]
```

| Option   | Description                                   |
| -------- | --------------------------------------------- |
| `-h`     | Show help                                     |
| `-v`     | Show script version                           |
| `-L`     | Create user with a **restricted environment** |
| `-r`     | Remove user (keep home folder)                |
| `-R`     | Remove user **and** their home folder         |
| *(none)* | Create regular user and generate SSH keys     |


🔒 Restricted User Mode (-L)
When using -L, the script:

- Creates a user with shell /bin/rbash

- Locks the user's .bash_profile with chattr +i

- Sets a custom PATH to include only a bin folder with symbolic links

- Enables only limited commands (currently only ls)

This is useful for creating users with minimal permissions in a controlled environment.


Examples
Create a regular user:
```
./manage-user alice
```
Create a restricted user:
```
./manage-user bob -L
```
Remove user but keep home directory:

```
./manage-user alice -r
```
Remove user and their home directory:

```
./manage-user bob -R
```
Show help:

```
./manage-user -h
```
Show version:

```
./manage-user -v
```


⚙️ Requirements
Run as root or with sudo

Linux system with:

bash, adduser, deluser

ssh-keygen

chattr, ln, rm, mkdir, etc.
