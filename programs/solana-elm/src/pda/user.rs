use anchor_lang::prelude::*;

pub const SEED: &str = "user";

pub const SIZE: usize = 8 // discriminator
    + 1; // increment

#[account]
pub struct User {
    pub increment: u8,
}
