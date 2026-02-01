package ai.aren.app.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class ArenProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", ArenCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", ArenCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", ArenCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", ArenCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", ArenCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", ArenCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", ArenCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", ArenCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", ArenCapability.Canvas.rawValue)
    assertEquals("camera", ArenCapability.Camera.rawValue)
    assertEquals("screen", ArenCapability.Screen.rawValue)
    assertEquals("voiceWake", ArenCapability.VoiceWake.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", ArenScreenCommand.Record.rawValue)
  }
}
