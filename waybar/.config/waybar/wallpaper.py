#!/usr/bin/env python3
import posix
import os
import subprocess
from pathlib import Path
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GLib, GdkPixbuf

WALLPAPER_DIR = Path.home() / "Pictures"
CACHE_DIR = Path.home() / ".cache" / "wallpapers"
CACHE_DIR.mkdir(parents=True, exist_ok=True)

class WallpaperSelector(Gtk.Window):
    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.destroy()
    
    # Получаем горизонтальный скроллбар
        hscrollbar = self.scroll.get_hscrollbar()
        if hscrollbar:
            adjustment = hscrollbar.get_adjustment()
            current = adjustment.get_value()
            page_size = adjustment.get_page_size()
        
        # Стрелка влево
            if event.keyval == Gdk.KEY_Left:
                new_value = max(0, current - page_size / 2)
                adjustment.set_value(new_value)
        
        # Стрелка вправо
            elif event.keyval == Gdk.KEY_Right:
                max_value = adjustment.get_upper() - page_size
                new_value = min(max_value, current + page_size / 2)
                adjustment.set_value(new_value)

    def __init__(self):
        super().__init__(title="Обои")
        self.set_default_size(1536, 180)
        self.set_decorated(True)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_keep_above(True)
        self.set_resizable(False)
        
        wallpapers = self.get_wallpapers()
        
        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        box.set_homogeneous(False)

        for wp in wallpapers[:12]:
            thumb = self.create_thumbnail(wp)
            if thumb:
                button = Gtk.Button()
                button.set_relief(Gtk.ReliefStyle.NONE)
                
                pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(str(thumb), 320, 180)
                image = Gtk.Image.new_from_pixbuf(pixbuf)
                
                button.set_image(image)
                button.set_always_show_image(True)
                button.set_size_request(160, 90)
                button.connect("clicked", self.on_wallpaper_clicked, wp)
                box.pack_start(button, False, False, 0)
        
        self.scroll = Gtk.ScrolledWindow()
        self.scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.NEVER)
        self.scroll.set_kinetic_scrolling(True)
        
        # Viewport обязателен для Box внутри ScrolledWindow
        viewport = Gtk.Viewport()
        viewport.add(box)
        self.scroll.add(viewport)
        
        self.add(self.scroll)
        self.load_css()
        self.connect("key-press-event", self.on_key_press)
        self.scroll.connect("scroll-event", self.on_scroll_event)

    
    def get_wallpapers(self):
        extensions = ['*.jpg', '*.jpeg', '*.png', '*.webp']
        wallpapers = []
        for ext in extensions:
            wallpapers.extend(WALLPAPER_DIR.glob(ext))
            wallpapers.extend(WALLPAPER_DIR.glob(ext.upper()))
        return sorted(wallpapers)[:20]
    
    def create_thumbnail(self, wallpaper_path):
        thumb_path = CACHE_DIR / f"{wallpaper_path.stem}.png"
        
        if not thumb_path.exists():
            try:
                subprocess.run([
                    'convert', str(wallpaper_path),
                    '-resize', '200x200^',
                    '-gravity', 'top',
                    '-extent', '200x200',
                    str(thumb_path)
                ], check=True, capture_output=True)
            except Exception as e:
                print(f"Ошибка создания превью: {e}")
                return None
        
        return str(thumb_path)
    
    def on_wallpaper_clicked(self, button, wallpaper_path):
        subprocess.Popen([
            'swaybg',
            '-m', 'fill',
            '-i', str(wallpaper_path)
       ], start_new_session=True)
    
        self.destroy()
    
    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.destroy()

        hscrollbar = self.scroll.get_hscrollbar()
        if hscrollbar:
            adjustment = hscrollbar.get_adjustment()
            current = adjustment.get_value()
            page_size = adjustment.get_page_size()
        
        # Стрелка влево
        if event.keyval == Gdk.KEY_Left:
            new_value = max(0, current - page_size / 2)
            adjustment.set_value(new_value)
        
        # Стрелка вправо
        elif event.keyval == Gdk.KEY_Right:
            max_value = adjustment.get_upper() - page_size
            new_value = min(max_value, current + page_size / 2)
            adjustment.set_value(new_value)

    def on_scroll_event(self, widget, event):
        hscrollbar = self.scroll.get_hscrollbar()
        if hscrollbar:
            adjustment = hscrollbar.get_adjustment()
            current = adjustment.get_value()
        
        # Колёсико вверх/влево
            if event.direction == Gdk.ScrollDirection.UP or \
               event.direction == Gdk.ScrollDirection.LEFT:
                adjustment.set_value(current - 50)
        
        # Колёсико вниз/вправо
            elif event.direction == Gdk.ScrollDirection.DOWN or \
                 event.direction == Gdk.ScrollDirection.RIGHT:
                adjustment.set_value(current + 50)
    
    def load_css(self):
        css = b"""
        window {
            background-color: #1e1e2e;
            border-radius: 12px;
            border: 0px solid #45475a;
        }
        
        button {
            background-color: #181825;
            border: 0px solid #45475a;
            border-radius: 0px;
            padding: 0px;
            margin: 0px;
        }
    
        button:hover {
            border-color: #89b4fa;
            background-color: #313244;
        }
    
        button:active {
            border-color: #a6e3a1;
            background-color: #2a2a3a;
        }
    
        image {
            margin: 0px;
        }
    
        scrollbar {
            background-color: #181825;
            border-radius: 0px;
           min-width: 0px;
        }
       
        scrollbar slider {
           background-color: #45475a;
            border-radius: 0px;
            min-height: 0px;
        }
       
        scrollbar slider:hover {
            background-color: #585b70;
        }
    
       flowbox {
            background-color: transparent;
            padding: 0px;
        }
    
        flowboxchild {
            padding: 0;
        }
    
        scrolledwindow {
           background-color: transparent;
       }
      """
        style_provider = Gtk.CssProvider()
        style_provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            style_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

if __name__ == "__main__":
    win = WallpaperSelector()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()

