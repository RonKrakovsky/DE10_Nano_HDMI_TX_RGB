

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------

entity VGA_IMAGE_RGB is
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
end VGA_IMAGE_RGB;  

--------------------------------------------------

architecture behav of VGA_IMAGE_RGB is
type mem_t is array(0 to 19200-1) of unsigned(24-1 downto 0); 
signal ram : mem_t;
attribute ram_init_file : string;
attribute ram_init_file of ram :
signal is "mif5.mif";

signal rgb : std_logic_vector(23 downto 0);
signal counter,x1,x2,counter_display : integer;
signal start : std_logic;
begin

    process(csi_sink_clk, rsi_sink_reset)
    begin
		if rsi_sink_reset = '0' then 
			counter <= 0;
			x1 <= 0;
			x2 <= 0;
			counter_display <= 0;
			start <= '0';
		elsif rising_edge(csi_sink_clk) then 
			if reset_pixels_v = '1' and reset_pixels_h = '1' then 
				counter <= 0; 
				x1 <= 640;
				x2 <= 1280;
				counter_display <= 0;
				start <= '0';
			elsif v_act = '1' and h_act = '1' then 
				if counter > 76800 then
					rgb <= (others => '1');
				else
					if counter < x1 and counter > (x1 - 480) then 
						rgb <= (others => '1');
					else
						if counter < x2 and counter > (x2 - 480) then 
							rgb <= (others => '1');
						elsif start = '1' then
							rgb <= std_logic_vector(ram(counter_display));
							counter_display <= counter_display + 1;
						else
							start <= '1';
						end if;
						
					end if;
					
					if counter = x1 then 
						x1 <= x1 + 640;
					end if;
					
					if counter = x2 then 
						x2 <= x2 + 640;
					end if;
					
				end if;
				
				counter <= counter + 1;
			else
				start <= '0';
			end if;	
		end if;
    end process;

aso_source_vga_r <= rgb(23 downto 16);
aso_source_vga_g <= rgb(15 downto 8);
aso_source_vga_b <= rgb(7 downto 0);

end behav;