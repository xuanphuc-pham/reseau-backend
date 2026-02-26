const authService = require("../services/auth");


async function authenticate(req, res, next) {
  try {

    let token = req.cookies?.session_token;

    if (!token) {
      const authHeader = req.headers.authorization;
      if (authHeader && authHeader.startsWith("Bearer ")) {
        token = authHeader.slice(7);
      }
    }

    if (!token) {
      return res
        .status(401)
        .json({ success: false, error: "Authentication required" });
    }

    // Token
    let decoded;
    try {
      decoded = authService.verifyToken(token);
    } catch (err) {
      return res
        .status(401)
        .json({ success: false, error: "Token expiré ou invalide" });
    }

    // Si expire
    const session = await authService.findSession(token);
    if (!session) {
      return res
        .status(401)
        .json({ success: false, error: "Session expirée ou invalide" });
    }

    // Permission et pas banni
    const result = await authService.getUserWithPermissions(decoded.userId);
    if (!result) {
      return res.status(401).json({ success: false, error: "Utilisateur introuvable" });
    }

    const isBanned = result.user.roles.some((r) => r.role_name === "Banned");
    if (isBanned) {
      return res
        .status(403)
        .json({ success: false, error: "Compte banni" });
    }

    req.user = result.user;
    req.permissions = result.permissions;
    req.token = token;

    next();
  } catch (err) {
    next(err);
  }
}

async function optionalAuth(req, res, next) {
  try {
    let token = req.cookies?.session_token;
    if (!token) {
      const authHeader = req.headers.authorization;
      if (authHeader && authHeader.startsWith("Bearer ")) {
        token = authHeader.slice(7);
      }
    }

    if (!token) {
      req.user = null;
      req.permissions = [];
      return next();
    }

    let decoded;
    try {
      decoded = authService.verifyToken(token);
    } catch (err) {
      req.user = null;
      req.permissions = [];
      return next();
    }

    const session = await authService.findSession(token);
    if (!session) {
      req.user = null;
      req.permissions = [];
      return next();
    }

    const result = await authService.getUserWithPermissions(decoded.userId);
    if (result) {
      req.user = result.user;
      req.permissions = result.permissions;
      req.token = token;
    } else {
      req.user = null;
      req.permissions = [];
    }

    next();
  } catch (err) {
    next(err);
  }
}

module.exports = { authenticate, optionalAuth };
