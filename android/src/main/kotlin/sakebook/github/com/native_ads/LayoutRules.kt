package sakebook.github.com.native_ads

enum class LayoutRules {
    alignParentLeft,
    alignParentTop,
    alignParentRight,
    alignParentBottom,
    above,
    below,
    toLeftOf,
    toRightOf,
    ;

    companion object {
        fun from(string: String): LayoutRules {
            return values().first { string.contains(it.name) }
        }
    }
}