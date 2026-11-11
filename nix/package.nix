{
  self,
  lib,
  buildGoModule,
  makeWrapper,
  mpv,
}:
buildGoModule {
  pname = "subtui";
  version = "unstable-${self.shortRev or self.dirtyShortRev or "dev"}";

  src = lib.cleanSource ../.;

  vendorHash = "sha256-XtTO9muHlPJu+BHk2+bt7M4tCNGud52cjAswCFpjv2w=";
  proxyVendor = true;

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/SubTUI $out/bin/subtui
    wrapProgram $out/bin/subtui --prefix PATH : ${lib.makeBinPath [ mpv ]}
  '';

  meta = with lib; {
    description = "A lightweight Subsonic TUI music player with scrobbling and mpv backend";
    homepage = "https://github.com/MattiaPun/SubTUI";
    license = licenses.mit;
    mainProgram = "subtui";
  };
}
