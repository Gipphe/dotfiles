{ fetchFromGitHub }: {
  community = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "community-plugins";
    rev = "a02a32ed859ad7c95f6a0567dfe03c88c34461d6";
    hash = "sha256-JcWj2fASKunn7Dd7Kb/sJHKBq80AIafRGFrUhnfJ88A=";
  };
  official = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "official-plugins";
    rev = "8cb833c3e2502f57e49d34fa64386b4d66794b77";
    hash = "";
  };
}
