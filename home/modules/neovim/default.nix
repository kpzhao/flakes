{ pkgs, ...}: 
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      everforest
      luasnip
      vim-lastplace
      editorconfig-nvim
      lualine-nvim
      which-key-nvim
      lualine-lsp-progress
      comment-nvim
    ];
    extraConfig = ''
      :source ${./nvim.lua}
    '';
  };
}
