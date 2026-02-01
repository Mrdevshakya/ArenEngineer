package ai.aren.app.ui

import androidx.compose.runtime.Composable
import ai.aren.app.MainViewModel
import ai.aren.app.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
