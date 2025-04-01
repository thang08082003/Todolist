package com.example.todolist

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.widget.RemoteViews
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.*

class HomeScreenWidget : HomeWidgetProvider() {
    private val db = FirebaseFirestore.getInstance()

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        listenForTaskUpdates(context)
    }

    override fun onDisabled(context: Context) {}

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val today = SimpleDateFormat(Constants.DATE_FORMAT, Locale.getDefault()).format(Date())
        val currentUserUid = FirebaseAuth.getInstance().currentUser?.uid

        if (currentUserUid != null) {
            db.collection(Constants.COLLECTION_TODOLIST)
                .whereEqualTo(Constants.FIELD_UID, currentUserUid)
                .whereEqualTo(Constants.FIELD_DATE_TASK, today)
                .get()
                .addOnSuccessListener { documents ->
                    val taskList = documents.map {
                        val taskTitle = it.getString(Constants.FIELD_TITLE_TASK) ?: Constants.UNKNOWN_TASK_TITLE
                        val taskTime = it.getString(Constants.FIELD_TIME_TASK) ?: Constants.UNKNOWN_TASK_TIME
                        val category = it.getString(Constants.FIELD_CATEGORY) ?: Constants.CATEGORY_GENERAL
                        TaskItem(taskTitle, category, taskTime)
                    }
                    updateWidgetWithTasks(context, appWidgetManager, appWidgetId, taskList)
                }
                .addOnFailureListener { e ->
                    Log.e("HomeScreenWidget", "Error retrieving tasks", e)
                }
        }
    }

    private fun updateWidgetWithTasks(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        tasks: List<TaskItem>
    ) {
        val views = RemoteViews(context.packageName, R.layout.home_screen_widget)
        views.removeAllViews(R.id.appwidget_task_list)

        tasks.forEach { task ->
            val taskView = RemoteViews(context.packageName, R.layout.task_item)
            taskView.setTextViewText(R.id.task_item_title, task.title)
            taskView.setTextViewText(R.id.task_item_time, task.time)

            val taskColor = when (task.category) {
                Constants.CATEGORY_LEARN -> Constants.LEARN_COLOR
                Constants.CATEGORY_WORK -> Constants.WORK_COLOR
                else -> Constants.GENERAL_COLOR
            }
            taskView.setTextColor(R.id.task_item_title, taskColor)

            views.addView(R.id.appwidget_task_list, taskView)
        }

        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_root_layout, pendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun listenForTaskUpdates(context: Context) {
        val currentUserUid = FirebaseAuth.getInstance().currentUser?.uid

        if (currentUserUid != null) {
            db.collection(Constants.COLLECTION_TODOLIST)
                .whereEqualTo(Constants.FIELD_UID, currentUserUid)
                .addSnapshotListener { snapshots, e ->
                    if (e != null) {
                        Log.w("HomeScreenWidget", "Listen failed.", e)
                        return@addSnapshotListener
                    }

                    if (snapshots != null && !snapshots.isEmpty) {
                        updateAllWidgets(context)
                    }
                }
        }
    }

    companion object {
        fun updateAllWidgets(context: Context) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(
                ComponentName(context, HomeScreenWidget::class.java)
            )
            val intent = Intent(context, HomeScreenWidget::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
            }
            context.sendBroadcast(intent)
        }
    }
}

data class TaskItem(val title: String, val category: String, val time: String)
