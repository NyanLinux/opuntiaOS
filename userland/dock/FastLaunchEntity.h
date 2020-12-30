#pragma once
#include <libg/PixelBitmap.h>
#include <libg/String.h>
#include <std/LinkedList.h>

class FastLaunchEntity : public LinkedListNode<FastLaunchEntity> {
public:
    FastLaunchEntity() = default;

    void set_icon(LG::PixelBitmap&& icon) { m_icon = move(icon); }
    const LG::PixelBitmap& icon() const { return m_icon; }

    void set_path_to_exec(LG::String&& path) { m_path_to_exec = move(path); }
    const LG::String& path_to_exec() const { return m_path_to_exec; }

private:
    LG::PixelBitmap m_icon;
    LG::String m_path_to_exec {};
};