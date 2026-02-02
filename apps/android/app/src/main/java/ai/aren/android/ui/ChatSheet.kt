package ai.aren.android.ui

import androidx.compose.runtime.Composable
import ai.aren.android.MainViewModel
import ai.aren.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
