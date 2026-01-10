import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../modelo/User.dart' as model;

class Access {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> registrarUsuario({
    required String email, 
    required String password, 
    required String nombre
  }) async {
    try {
      UserCredential credencial = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credencial.user!.updateDisplayName(nombre.trim()); 
      await credencial.user!.reload();

      String uid = credencial.user!.uid;
      model.User nuevoUsuario = model.User(
        uid: uid,
        email: email.trim(),
        displayName: nombre.trim(),
        role: 'user',
        status: 'active',
      );
      await _db.collection('users').doc(uid).set(nuevoUsuario.toMap());
    } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return 'La contraseña debe tener al menos 6 caracteres';
        } else if (e.code == 'email-already-in-use') {
          return 'Este correo ya está registrado';
        } else if (e.code == 'invalid-email') {
          return 'El formato del correo es incorrecto';
        } else {
            return 'Ocurrió un error inesperado. Intenta más tarde';
        }
    } catch (e) {
      return "Error desconocido: $e";
    }
    return null;
  }

  
  Future<String?> iniciarSesion(String email, String password) async {
    try {
      
      UserCredential credencial = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      
      await _db.collection('users').doc(credencial.user!.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return null;
    
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
      case 'user-not-found':
        return 'No existe ninguna cuenta asociada con este correo.';
      case 'wrong-password':
        return 'La contraseña es incorrecta.';
      case 'invalid-email':
        return 'El correo no tiene un formato válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido inhabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Por seguridad, espera unos minutos.';
      case 'invalid-credential':
        return 'El Correo o contraseña ingresados son incorrectos.';
      default:
        return e.message ?? 'Ocurrió un error inesperado al iniciar sesión.';
    }
  }
}

  
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  
  Future<String?> registroGoogle({bool esRegistro = false}) async {
    try {
    await GoogleSignIn().signOut();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
    if (googleUser == null) return "Cancelado por el usuario";

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    String uid = userCredential.user!.uid;
    DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();

    if (userDoc.exists) {
      if (esRegistro) {
        await _auth.signOut();
        return "YA_EXISTE";
      }
      await _db.collection('users').doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } else {
      model.User nuevoUsuario = model.User(
        uid: uid,
        email: userCredential.user!.email,
        displayName: userCredential.user!.displayName,
        role: 'user',        
        status: 'active',
        photoURL: userCredential.user!.photoURL, 
      );
      
      await _db.collection('users').doc(uid).set(nuevoUsuario.toMap());
    }

    return null;

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
    case 'account-exists-with-different-credential':
      return 'Este correo ya se registró con otro método.';
    case 'invalid-credential':
      return 'Las credenciales de Google caducaron o son inválidas.';
    case 'operation-not-allowed':
      return 'El acceso con Google no está habilitado.';
    case 'user-disabled':
      return 'Esta cuenta ha sido inhabilitada.';
    default:
      return "Ocurrió un error inesperado. Intenta de nuevo más tarde.";
  }
    } catch (e) {
      return "Ocurrió un error inesperado. Intenta de nuevo más tarde.";
    }
  }
}