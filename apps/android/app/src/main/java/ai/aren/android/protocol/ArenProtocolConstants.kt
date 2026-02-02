package ai.aren.android.protocol

enum class ArenCapability(val rawValue: String) {
  Canvas("canvas"),
  Camera("camera"),
  Screen("screen"),
  Sms("sms"),
  VoiceWake("voiceWake"),
  Location("location"),
}

enum class ArenCanvasCommand(val rawValue: String) {
  Present("canvas.present"),
  Hide("canvas.hide"),
  Navigate("canvas.navigate"),
  Eval("canvas.eval"),
  Snapshot("canvas.snapshot"),
  ;

  companion object {
    const val NamespacePrefix: String = "canvas."
  }
}

enum class ArenCanvasA2UICommand(val rawValue: String) {
  Push("canvas.a2ui.push"),
  PushJSONL("canvas.a2ui.pushJSONL"),
  Reset("canvas.a2ui.reset"),
  ;

  companion object {
    const val NamespacePrefix: String = "canvas.a2ui."
  }
}

enum class ArenCameraCommand(val rawValue: String) {
  Snap("camera.snap"),
  Clip("camera.clip"),
  ;

  companion object {
    const val NamespacePrefix: String = "camera."
  }
}

enum class ArenScreenCommand(val rawValue: String) {
  Record("screen.record"),
  ;

  companion object {
    const val NamespacePrefix: String = "screen."
  }
}

enum class ArenSmsCommand(val rawValue: String) {
  Send("sms.send"),
  ;

  companion object {
    const val NamespacePrefix: String = "sms."
  }
}

enum class ArenLocationCommand(val rawValue: String) {
  Get("location.get"),
  ;

  companion object {
    const val NamespacePrefix: String = "location."
  }
}
