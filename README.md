# BBTrends España — Extensiones AL Business Central

**Repo:** BBtrends-git/Spain
**Última actualización:** 14/07/2026

---

## Estructura del repositorio

| Carpeta | Módulo | Versión actual |
|---|---|---|
| `BBTrends APIs` | APIs | v28.0.1.3 |
| `BBTrends Base` | Base | v28.0.1.23 |
| `BBTrends RMAs` | RMAs | v28.0.1.3 |
| `BBTrends SCM` | SCM | v28.0.1.1 |
| `BBTrends SGA` | SGA | v28.0.1.8 |
| `BBTrends Shopify` | Shopify | v28.0.1.6 |
| `BBTrends SMG` | SMG | v28.0.1.6 |
| `BBTrends SRM` | SRM | v28.0.1.1 |
| `BBTrends Tools` | Tools | v28.0.1.3 |
| `BBTrends Tools_IT` | Tools IT | v28.0.1.3 |

---

## Flujo de trabajo

### 1. Configuración inicial (una sola vez)

| Paso | Responsable | Acción |
|---|---|---|
| 1 | Partner | Crear cuenta GitHub y comunicar el usuario a BBTrends |
| 2 | BBTrends | Añadir usuario como Collaborator con rol **Write** en el repo |
| 3 | Partner | Aceptar la invitación recibida por email de GitHub |
| 4 | Partner | Clonar el repositorio: `git clone https://github.com/BBtrends-git/Spain.git` |

---

### 2. Flujo por cada nueva versión o mejora

**Paso 1 — Partner crea una branch de trabajo**
```
git checkout -b BBTrends-Base/fix-nombre-del-cambio
```
El nombre de la branch debe ser descriptivo e incluir el módulo afectado.

**Paso 2 — Partner realiza los cambios y los sube**
```
git add .
git commit -m "Descripción del cambio"
git push origin BBTrends-Base/fix-nombre-del-cambio
```

**Paso 3 — Partner abre un Pull Request (PR)**

Desde GitHub, el partner abre un Pull Request hacia `main` indicando:
- Descripción del cambio realizado
- Módulo afectado
- Versión nueva propuesta

**Paso 4 — BBTrends revisa y aprueba**

BBTrends recibe notificación por email, revisa los cambios línea a línea en GitHub y puede añadir comentarios si algo no es correcto.

**Paso 5 — Merge y tag de versión**

Una vez aprobado, BBTrends hace Merge del PR a `main` y crea un tag con la nueva versión:
```
git tag BBTrends-Base/v28.0.1.23
git push origin BBTrends-Base/v28.0.1.23
```

---

### 3. Reglas del flujo

- El partner **nunca trabaja directamente en `main`**
- Todo cambio entra en `main` únicamente mediante Pull Request aprobado por BBTrends
- Cada entrega queda registrada con su tag de versión en GitHub
- Los nombres de branch siguen el formato: `MODULO/descripcion-del-cambio`

---

## Contacto

| | BBTrends |
|---|---|
| GitHub | BBtrends-git |
| Email | github@bbtrends.es |
