

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------

entity VGA_IMAGE is
port(	
	csi_sink_clk	 	 : in std_logic; -- clock
	rsi_sink_reset	 	 : in std_logic; -- reset in LOW = '0'
	reset_pixels_v   	 : in std_logic;
	reset_pixels_h   	 : in std_logic;
	v_act				 : in std_logic;
	h_act				 : in std_logic;
	aso_source_vga_r	 : out std_logic_vector(7 downto 0);
	aso_source_vga_g	 : out std_logic_vector(7 downto 0);
	aso_source_vga_b	 : out std_logic_vector(7 downto 0)


);
end VGA_IMAGE;  

--------------------------------------------------

architecture behav of VGA_IMAGE is
type mem_t is array(0 to 307200-1) of unsigned(1-1 downto 0); 
signal ram : mem_t;
attribute ram_init_file : string;
attribute ram_init_file of ram :
signal is "MIF_IMAGE.mif";

signal rgb : std_logic_vector(23 downto 0);
signal counter : integer;
begin

    process(csi_sink_clk, rsi_sink_reset)
    begin
		if rsi_sink_reset = '0' then 
			counter <= 0;
		elsif rising_edge(csi_sink_clk) then 
			if reset_pixels_v = '1' and reset_pixels_h = '1' then 
				counter <= 0; 
			elsif v_act = '1' and h_act = '1' then 
				if ram(counter) = 1 then
					rgb <= (others => '1');
				else
					rgb <= (others => '0');
				end if;
				counter <= counter + 1;
			end if;	
		end if;
    end process;

aso_source_vga_r <= rgb(23 downto 16);
aso_source_vga_g <= rgb(15 downto 8);
aso_source_vga_b <= rgb(7 downto 0);

end behav;