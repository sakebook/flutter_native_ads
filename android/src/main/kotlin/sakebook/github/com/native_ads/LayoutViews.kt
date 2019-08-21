package sakebook.github.com.native_ads

enum class LayoutViews {
    headline,
    image,
    body,
    icon,
    callToAction,
    media,
    ;

    companion object {
        fun from(string: String): LayoutViews {
            return values().first { string.contains(it.name) }
        }
    }

    fun viewId(): ViewId {
        return when (this) {
            headline -> 100
            image -> 101
            body -> 102
            icon -> 103
            callToAction -> 104
            media -> 105
        }
    }
}