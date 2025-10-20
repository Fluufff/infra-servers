{ stdenv, fetchFromGitHub, libjson-c, systemd, libcurl, libutempter, pkg-config }:

stdenv.mkDerivation rec {
  pname = "tlog";
  version = "…"; # set version
  src = fetchFromGitHub {
    owner = "scribery";
    repo = "tlog";
    rev = "...";
    sha256 = "...";
  };

  nativeBuildInputs = [ pkg-config systemd ];
  buildInputs = [ libjson-c libcurl libutempter ];

  # configure, make, install phases
  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out --sysconfdir=/etc --localstatedir=/var \
      --with-systemd-journal # or whatever options you like
  '';

  # install as usual
}