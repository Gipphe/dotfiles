import { App, Astal, Gtk, Gdk } from "astal/gtk4";
import { bind, Variable } from "astal";
import Tray from "gi://AstalTray";
import Network from "gi://AstalNetwork";
import Wp from "gi://AstalWp";
import Battery from "gi://AstalBattery";
import Mpris from "gi://AstalMpris";

const time = Variable("").poll(1000, "date");

const SysTray = () => {
  const tray = Tray.get_default();
  return (
    <box cssClasses={["SysTray"]}>
      {bind(tray, "items").as((items) =>
        items.map((item) => {
          const popover = Gtk.PopoverMenu.new_from_model(item.menuModel);
          popover.insert_action_group("dbusmenu", item.actionGroup);
          item.connect("notify::action-group", () => {
            popover.insert_action_group("dbusmenu", item.actionGroup);
          });
          return (
            <menubutton
              tooltipMarkup={bind(item, "tooltipMarkup")}
              menuModel={bind(item, "menuModel")}
              popover={popover}
            >
              <image gicon={bind(item, "gicon")} />
            </menubutton>
          );
        }),
      )}
    </box>
  );
};

const Wifi = () => {
  const network = Network.get_default();
  const wifi = bind(network, "wifi");
  return (
    <box visible={wifi.as(Boolean)}>
      {wifi.as(
        (wifi) =>
          wifi && (
            <image
              tooltipText={bind(wifi, "ssid").as(String)}
              cssClasses={["Wifi"]}
              iconName={bind(wifi, "iconName")}
            />
          ),
      )}
    </box>
  );
};

const AudioSlider = () => {
  const speaker = Wp.get_default()?.audio.defaultSpeaker;
  if (!speaker) {
    return null;
  }

  return (
    <box cssClasses={["AudioSlider"]} cssName="min-width: 140px">
      <image iconName={bind(speaker, "volumeIcon")} />
      <slider hexpand onMotion={(slider) => (speaker.volume = slider.value)} />
    </box>
  );
};

const BatteryLevel = () => {
  const bat = Battery.get_default();

  return (
    <box cssClasses={["Battery"]} visible={bind(bat, "isPresent")}>
      <image iconName={bind(bat, "batteryIconName")} />
      <label
        label={bind(bat, "percentage").as((p) => `${Math.floor(p * 100)} %`)}
      />
    </box>
  );
};

const Media = () => {
  const mpris = Mpris.get_default();

  const playing = (ps: Mpris.Player[]) => (
    <box
      cssClasses={["Cover"]}
      valign={Gtk.Align.CENTER}
      setup={(b) => {
        bind(ps[0], "coverArt")
          .as((cover) => `background-image: url('${cover}');`)
          .subscribe((i) => {
            b.cssName = i;
          });
      }}
      cssName={}
    >
      <label
        label={bind(ps[0], "metadata").as(
          () => `${ps[0].title} - ${ps[0].artist}`,
        )}
      />
    </box>
  );

  return (
    <box cssClasses={["Media"]}>
      {bind(mpris, "players").as((ps) => (ps[0] ? playing : nothingPlaying))}
    </box>
  );
};

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      visible
      cssClasses={["Bar"]}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <centerbox cssName="centerbox">
        <menubutton hexpand halign={Gtk.Align.START}>
          <label label="Apps" />
          <popover>
            <box>App drawer</box>
          </popover>
        </menubutton>
        <box />
        <menubutton hexpand halign={Gtk.Align.END}>
          <label label={time()} />
          <popover>
            <Gtk.Calendar />
          </popover>
        </menubutton>
      </centerbox>
    </window>
  );
}
